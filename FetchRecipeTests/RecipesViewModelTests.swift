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
        viewModel = RecipesViewModel()
    }
    
    func testLoadAllRecipes() async {
        await viewModel.loadAllRecipes()
        XCTAssertFalse(viewModel.displayedRecipes.isEmpty)
    }
    
    func testRefreshRecipes() async {
        await viewModel.refreshRecipes()
        XCTAssertFalse(viewModel.displayedRecipes.isEmpty)
    }
    
    func testLoadMoreRecipes() async throws {
        await viewModel.loadAllRecipes()  // Load initial recipes
        
        let initialCount = viewModel.displayedRecipes.count
        XCTAssertGreaterThan(initialCount, 0, "Displayed recipes should not be empty after loading")
        
        print("Initial displayedRecipes count: \(initialCount)") // Debugging
        print("Total allRecipes count: \(viewModel.allRecipes.count)") // Debugging
        
        // Ensure `allRecipes` has enough data for pagination
        XCTAssertGreaterThan(viewModel.allRecipes.count, initialCount, "There should be more recipes available to load")
        
        let expectation = expectation(description: "Load More Recipes Completes")
        
        Task {
            viewModel.loadMoreRecipes()
            try? await Task.sleep(nanoseconds: 1_500_000_000)  // Wait for `Task` execution
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 3.0)
        
        print("Final displayedRecipes count: \(viewModel.displayedRecipes.count)") // Debugging
        XCTAssertGreaterThan(viewModel.displayedRecipes.count, initialCount, "More recipes should be loaded")
    }
}
