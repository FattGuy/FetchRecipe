//
//  RecipesView.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel = RecipesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in  // Add ScrollViewReader for smooth scrolling
                ScrollView {
                    VStack {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.displayedRecipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeGridItem(recipe: recipe)
                                }
                                .onAppear {
                                    loadMoreContentIfNeeded(currentRecipe: recipe)
                                }
                            }
                        }
                        .padding()
                        .id("TOP")  // Used to scroll back to top smoothly
                    }

                    // Bottom Spinner (for Infinite Scrolling)
                    if viewModel.isLoadingMore {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding(.bottom, 40)
                            .frame(maxWidth: .infinity)
                    }
                }
                .refreshable {
                    await viewModel.refreshRecipes()

                    // Smoothly move navigation bar & collection together
                    withAnimation(.easeInOut(duration: 0.4)) {
                        scrollProxy.scrollTo("TOP", anchor: .top)
                    }
                }
                .navigationTitle("Recipes")
                .task {
                    await viewModel.loadAllRecipes()
                }
            }
        }
    }

    /// Triggers pagination when the last item appears
    private func loadMoreContentIfNeeded(currentRecipe: Recipe) {
        guard let lastRecipe = viewModel.displayedRecipes.last else { return }
        if currentRecipe.id == lastRecipe.id {
            viewModel.loadMoreRecipes()
        }
    }
}

#Preview {
    RecipesView()
}
