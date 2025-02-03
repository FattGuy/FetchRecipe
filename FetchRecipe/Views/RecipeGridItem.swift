//
//  RecipeGridItem.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import SwiftUI

struct RecipeGridItem: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            // Recipe Image
            //TODO:

            // Recipe Name
            Text(recipe.name)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
                .lineLimit(2)

            // Cuisine Type
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 2)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        .shadow(radius: 2)
    }
}
