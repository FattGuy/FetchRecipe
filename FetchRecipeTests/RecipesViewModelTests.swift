//
//  RecipesViewModelTests.swift
//  FetchRecipeTests
//
//  Created by Feng Chang on 2/3/25.
//

import XCTest
@testable import FetchRecipe

@MainActor
class RecipesViewModelTests: XCTestCase {
    var viewModel: RecipesViewModel!
    var mockNetworkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let mockSession = URLSessionMock()
        mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
    }
    
    // Test Loading All Recipes (Success)
    func testLoadAllRecipes() async {
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Test Recipe",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON)
        let mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
        
        await viewModel.loadAllRecipes()
        XCTAssertFalse(viewModel.displayedRecipes.isEmpty, "Recipes should be successfully loaded")
    }
    
    // Test Refreshing Recipes
    func testRefreshRecipes() async {
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Refreshed Recipe",
                    "cuisine": "French",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON)
        let mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
        
        await viewModel.refreshRecipes()
        XCTAssertFalse(viewModel.displayedRecipes.isEmpty, "Refreshing should fetch new recipes")
    }
    
    // Test Loading More Recipes (Pagination)
    func testLoadMoreRecipes() async throws {
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe A",
                    "cuisine": "Mexican",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                },
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Recipe B",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON)
        let mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
        
        await viewModel.loadAllRecipes()
        let initialCount = viewModel.displayedRecipes.count
        XCTAssertGreaterThan(initialCount, 0, "Displayed recipes should not be empty after loading")
        
        let expectation = expectation(description: "Load More Recipes Completes")
        
        Task {
            viewModel.loadMoreRecipes()
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        XCTAssertGreaterThan(viewModel.displayedRecipes.count, initialCount, "More recipes should be loaded")
    }
    
    // Test Sorting Recipes (Ascending)
    func testSortRecipesAscending() {
        let mockRecipes = [
            Recipe(id: UUID(), name: "Banana Pancakes", cuisine: "American", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil),
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil),
            Recipe(id: UUID(), name: "Zucchini Bread", cuisine: "Italian", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil)
        ]
        
        viewModel.setMockRecipes(mockRecipes)
        viewModel.sortRecipes(ascending: true)
        
        let sortedNames = viewModel.displayedRecipes.map { $0.name }
        XCTAssertEqual(sortedNames, ["Apple Pie", "Banana Pancakes", "Zucchini Bread"], "Sorting should be A → Z")
    }
    
    // Test Sorting Recipes (Descending)
    func testSortRecipesDescending() {
        let mockRecipes = [
            Recipe(id: UUID(), name: "Banana Pancakes", cuisine: "American", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil),
            Recipe(id: UUID(), name: "Apple Pie", cuisine: "American", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil),
            Recipe(id: UUID(), name: "Zucchini Bread", cuisine: "Italian", sourceUrl: nil, youtubeUrl: nil, photoUrlSmall: nil, photoUrlLarge: nil)
        ]
        
        viewModel.setMockRecipes(mockRecipes)
        viewModel.sortRecipes(ascending: false)
        
        let sortedNames = viewModel.displayedRecipes.map { $0.name }
        XCTAssertEqual(sortedNames, ["Zucchini Bread", "Banana Pancakes", "Apple Pie"], "Sorting should be Z → A")
    }
    
    // Test Empty Recipes Response
    func testLoadEmptyRecipes() async {
        let emptyJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: emptyJSON)
        let mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
        
        await viewModel.loadAllRecipes()
        
        XCTAssertTrue(viewModel.allRecipes.isEmpty, "No recipes should be loaded")
        XCTAssertEqual(viewModel.errorMessage, "No recipes found. Please check back later.")
    }
    
    // Test Malformed JSON Response
    func testLoadMalformedRecipes() async {
        let malformedJSON = """
        {
            "recipes": [
                {
                    "id": "invalid-uuid",  // Invalid UUID
                    "name": "Banana Pancakes",
                    "cuisine": "American"
                    // Missing required fields
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: malformedJSON)
        let mockNetworkManager = NetworkManager(session: mockSession)
        viewModel = RecipesViewModel(networkManager: mockNetworkManager)
        
        await viewModel.loadAllRecipes()
        
        XCTAssertTrue(viewModel.allRecipes.isEmpty, "Malformed data should be discarded")
        XCTAssertEqual(viewModel.errorMessage, "We couldn't read the recipe data. Please try again later.")
    }
}
