//
//  RecipesViewModel.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import SwiftUI

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published private(set) var allRecipes: [Recipe] = []  // Full dataset from API
    @Published var displayedRecipes: [Recipe] = []  // Paged data for UI
    @Published var isLoadingMore = false  // Bottom spinner for infinite scrolling
    @Published var isRefreshing = false   // Top spinner for pull-to-refresh
    @Published var errorMessage: String?
    
    private let batchSize = 20  // Number of recipes to load per scroll
    
    /// Loads recipes initially
    func loadAllRecipes() async {
        guard !isRefreshing && !isLoadingMore else { return }
        
        isRefreshing = true
        errorMessage = nil
        
        do {
            allRecipes = try await NetworkManager.shared.fetchRecipes()
            displayedRecipes = Array(allRecipes.prefix(batchSize))
            
            // ✅ Handle Empty Recipes Case
            if allRecipes.isEmpty {
                errorMessage = "⚠️ No recipes available. Please check back later."
            }
        } catch let error as DecodingError {
            errorMessage = "⚠️ Failed to decode recipe data. Please try again later."
            print("❌ Decoding Error: \(error)")
        } catch {
            errorMessage = "⚠️ Network error: \(error.localizedDescription)"
            print("❌ Network Error: \(error)")
        }
        
        isRefreshing = false
    }
    
    /// Loads more recipes for infinite scrolling
    func loadMoreRecipes() {
        guard displayedRecipes.count < allRecipes.count, !isLoadingMore else { return }

        isLoadingMore = true

        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            await MainActor.run {
                let nextBatchEndIndex = min(self.displayedRecipes.count + self.batchSize, self.allRecipes.count)
                self.displayedRecipes.append(contentsOf: self.allRecipes[self.displayedRecipes.count..<nextBatchEndIndex])
                self.isLoadingMore = false
            }
        }
    }
    
    /// Allows users to manually refresh the list
    func refreshRecipes() async {
        guard !isRefreshing else { return }  // Prevent multiple refreshes
        
        isRefreshing = true  // Activate top spinner
        errorMessage = nil
        
        do {
            // Create a new Task to ensure it runs independently
            await Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000)  // 1.5s delay
            }.value  // Ensures it fully completes before proceeding
            
            // Now fetch new data
            allRecipes = try await NetworkManager.shared.fetchRecipes()
            displayedRecipes = Array(allRecipes.prefix(batchSize))  // Reset the displayed list
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isRefreshing = false  // Stop top spinner
    }
}
