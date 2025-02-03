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
        networkManager = NetworkManager.shared
    }
    
    func testFetchRecipesEmptyData() async {
        let emptyJSON = """
            {
                "recipes": []
            }
            """.data(using: .utf8)!  // Empty JSON structure
        
        let mockSession = URLSessionMock(
            data: emptyJSON,
            response: HTTPURLResponse(url: URL(string: "https://example.com")!,
                                      statusCode: 200, httpVersion: nil, headerFields: nil),
            error: nil
        )
        
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
                    "uuid": 123,  // Wrong data type (should be a string)
                    "name": 456,  // Wrong data type (should be a string)
                    "cuisine": null,  // Null value
                    "source_url": "not a url",  // Invalid URL format
                    "youtube_url": 100,  // Wrong data type
                    "photo_url_small": false,  // Wrong data type
                    "photo_url_large": []  // Wrong data type
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(
            data: malformedJSON,
            response: HTTPURLResponse(url: URL(string: "https://example.com")!,
                                      statusCode: 200, httpVersion: nil, headerFields: nil),
            error: nil
        )
        
        networkManager = NetworkManager(session: mockSession)
        
        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected DecodingError but got success response")
        } catch let error as DecodingError {
            XCTAssertNotNil(error, "Decoding error should be thrown")
        } catch {
            XCTFail("Expected DecodingError but got another error: \(error)")
        }
    }
    
    func testFetchRecipesSuccess() async throws {
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

        let mockSession = URLSessionMock(
            data: mockJSON,
            response: HTTPURLResponse(url: URL(string: "https://example.com")!,
                                      statusCode: 200, httpVersion: nil, headerFields: nil),
            error: nil
        )

        let networkManager = NetworkManager(session: mockSession)

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
        let mockSession = URLSessionMock(data: nil, response: nil, error: URLError(.badServerResponse))
        let networkManager = NetworkManager(session: mockSession)
        
        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected failure but succeeded")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testFetchRecipesNetworkFailure() async {
        let mockSession = URLSessionMock(data: nil, response: nil, error: URLError(.notConnectedToInternet))
        let networkManager = NetworkManager(session: mockSession)

        do {
            _ = try await networkManager.fetchRecipes()
            XCTFail("Expected network error but got success response")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}

