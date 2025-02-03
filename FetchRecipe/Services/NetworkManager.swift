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

    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw URLError(.badURL)
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            // Handle Empty Data Case
            guard !data.isEmpty else {
                print("⚠️ API returned empty data.")
                return []  // Return an empty list instead of throwing an error
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
                return recipeResponse.recipes
            } catch let decodingError as DecodingError {
                print("❌ JSON Decoding Error: \(decodingError)")
                throw decodingError  // Rethrow so ViewModel can handle it
            }

        } catch {
            print("❌ Network Error: \(error)")
            throw error
        }
    }
}
