//
//  RecipesViewModelTests.swift
//  FetchRecipeTests
//
//  Created by Feng Chang on 2/3/25.
//

import XCTest
@testable import MyRecipe

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
        await viewModel.loadAllRecipes()  // ✅ Load initial recipes
        
        let initialCount = viewModel.displayedRecipes.count
        XCTAssertGreaterThan(initialCount, 0, "Displayed recipes should not be empty after loading")
        
        // ✅ Ensure allRecipes has more than batchSize recipes
        XCTAssertGreaterThan(viewModel.allRecipes.count, initialCount, "There should be more recipes available to load")
        
        let expectation = expectation(description: "Load More Recipes Completes")  // ✅ Wait for Task to finish
        
        Task {
            viewModel.loadMoreRecipes()
            try? await Task.sleep(nanoseconds: 1_500_000_000)  // ✅ Give it time to complete
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 3.0)  // ✅ Test waits up to 3 seconds
        
        XCTAssertGreaterThan(viewModel.displayedRecipes.count, initialCount, "More recipes should be loaded")
    }
}
