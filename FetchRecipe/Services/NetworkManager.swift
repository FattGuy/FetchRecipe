//
//  NetworkManager.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Handle Empty Data Case
            guard !data.isEmpty else {
                print("API returned empty data.")
                return []  // Return an empty list instead of throwing an error
            }
            
            let decoder = JSONDecoder()
            
            do {
                let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
                
                // validation for malformed recipes
                let isMalformed = recipeResponse.recipes.contains { recipe in
                    guard let uuid = UUID(uuidString: recipe.id.uuidString) else { return true }
                    if recipe.name.trimmingCharacters(in: .whitespaces).isEmpty { return true }
                    if recipe.cuisine.trimmingCharacters(in: .whitespaces).isEmpty { return true }
                    if recipe.photoUrlLarge == nil || recipe.photoUrlSmall == nil { return true }
                    
                    return false
                }
                
                // If any recipe is malformed, discard the entire list
                if isMalformed {
                    print("Malformed data detected, discarding all recipes.")
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Malformed recipes detected"))
                }
                
                return recipeResponse.recipes
            } catch let decodingError as DecodingError {
                print("JSON Decoding Error: \(decodingError)")
                throw decodingError  // Rethrow so ViewModel can handle it
            }
            
        } catch {
            print("Network Error: \(error)")
            throw error
        }
    }
    
    /// Fetch All Recipes
    func fetchRecipes() async throws -> [Recipe] {
        return try await fetchRecipes(from: API.Endpoints.allRecipes)
    }
    
    /// Fetch Empty Recipes
    func fetchEmptyRecipes() async throws -> [Recipe] {
        return try await fetchRecipes(from: API.Endpoints.emptyRecipes)
    }
    
    /// Fetch Malformed Recipes
    func fetchMalformedRecipes() async throws -> [Recipe] {
        return try await fetchRecipes(from: API.Endpoints.malformedRecipes)
    }
}
