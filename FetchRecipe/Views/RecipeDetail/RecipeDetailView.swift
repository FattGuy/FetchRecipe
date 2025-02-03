//
//  RecipeDetailView.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Recipe Image (Large)
                if let imageUrlString = recipe.photoUrlLarge?.absoluteString, let imageUrl = URL(string: imageUrlString) {
                    AsyncImageView(url: imageUrl)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }

                // Cuisine Type
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                // External Links
                if let sourceUrlString = recipe.sourceUrl?.absoluteString, let sourceUrl = URL(string: sourceUrlString) {
                    Link("View Full Recipe", destination: sourceUrl)
                        .foregroundColor(.blue)
                        .font(.headline)
                }

                if let youtubeUrlString = recipe.youtubeUrl?.absoluteString, let youtubeUrl = URL(string: youtubeUrlString) {
                    Link("Watch on YouTube", destination: youtubeUrl)
                        .foregroundColor(.red)
                        .font(.headline)
                }

                Divider()
            }
            .padding()
        }
        .navigationTitle(recipe.name)
    }
}
