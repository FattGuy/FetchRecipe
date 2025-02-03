//
//  AppConstants.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation

enum API {
    static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    enum Endpoints {
        static let allRecipes = "\(baseURL)/recipes.json"
        static let malformedRecipes = "\(baseURL)/recipes-malformed.json"
        static let emptyRecipes = "\(baseURL)/recipes-empty.json"
    }
}
