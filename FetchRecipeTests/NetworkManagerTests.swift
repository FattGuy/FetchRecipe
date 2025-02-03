//
//  NetworkManagerTests.swift
//  FetchRecipeTests
//
//  Created by Feng Chang on 2/3/25.
//

import XCTest
@testable import FetchRecipe

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
    }
    
    func testFetchRecipesEmptyData() async {
        let emptyJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!

        let mockSession = URLSessionMock(data: emptyJSON)
        networkManager = NetworkManager(session: mockSession)

        do {
            let recipes = try await networkManager.fetchRecipes()
            XCTAssertTrue(recipes.isEmpty, "Recipes array should be empty")
        } catch {
            XCTFail("Expected empty array but got an error: \(error)")
        }
    }
    
    func testFetchRecipesMalformedData() async {
        let malformedJSON = """
        {
            "recipes": [
                {
                    "uuid": 123,  // Invalid UUID format
                    "name": 456,  // Should be a string
                    "cuisine": null,  // Null value
                    "photo_url_small": false,  // Should be a string
                    "photo_url_large": []  // Should be a string
                }
            ]
        }
        """.data(using: .utf8)!

        let mockSession = URLSessionMock(data: malformedJSON)
        networkManager = NetworkManager(session: mockSession)

        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected DecodingError but got success response")
        } catch is DecodingError {
            XCTAssertTrue(true, "Expected DecodingError was thrown correctly")
        } catch {
            XCTFail("Expected DecodingError but got another error: \(error)")
        }
    }
    
    func testFetchRecipesSuccess() async {
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Test Recipe",
                    "cuisine": "Italian",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg"
                }
            ]
        }
        """.data(using: .utf8)!

        let mockSession = URLSessionMock(data: mockJSON)
        networkManager = NetworkManager(session: mockSession)

        let expectation = expectation(description: "Fetching recipes completes")
        
        Task {
            do {
                let recipes = try await networkManager.fetchRecipes()
                XCTAssertEqual(recipes.count, 1)
                expectation.fulfill()  // ✅ Ensure the test does not cancel the request
            } catch {
                XCTFail("Request failed: \(error)")
            }
        }

        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func testFetchRecipesInvalidResponse() async {
        let mockSession = URLSessionMock(data: nil, statusCode: 500)  // Simulating Server Error (500)
        networkManager = NetworkManager(session: mockSession)

        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected failure but succeeded")
        } catch {
            XCTAssertTrue(error is URLError, "Expected URLError due to bad server response")
        }
    }
    
    func testFetchRecipesNetworkFailure() async {
        let mockSession = URLSessionMock(error: URLError(.notConnectedToInternet))
        networkManager = NetworkManager(session: mockSession)

        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected network error but got success response")
        } catch {
            XCTAssertTrue(error is URLError, "Expected URLError due to no internet connection")
        }
    }
}
