//
//  RecipeTests.swift
//  FetchRecipeTests
//
//  Created by Feng Chang on 2/3/25.
//

import XCTest
@testable import FetchRecipe

class RecipeTests: XCTestCase {
    func testRecipeDecoding() throws {
        let json = """
        {
            "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            "name": "Apple Frangipan Tart",
            "cuisine": "British",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk",
            "photo_url_small": "https://example.com/small.jpg",
            "photo_url_large": "https://example.com/large.jpg"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)

        XCTAssertEqual(recipe.id, UUID(uuidString: "74f6d4eb-da50-4901-94d1-deae2d8af1d1"))
        XCTAssertEqual(recipe.name, "Apple Frangipan Tart")
        XCTAssertEqual(recipe.cuisine, "British")
        XCTAssertEqual(recipe.sourceUrl?.absoluteString, "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble")
        XCTAssertEqual(recipe.youtubeUrl?.absoluteString, "https://www.youtube.com/watch?v=rp8Slv4INLk")
        XCTAssertEqual(recipe.photoUrlSmall?.absoluteString, "https://example.com/small.jpg")
        XCTAssertEqual(recipe.photoUrlLarge?.absoluteString, "https://example.com/large.jpg")
    }

    func testRecipeHandlesMissingFields() throws {
        let json = """
        {
            "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            "name": "Test Recipe",
            "cuisine": "Test Cuisine"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)

        XCTAssertEqual(recipe.name, "Test Recipe")
        XCTAssertNil(recipe.sourceUrl)
        XCTAssertNil(recipe.youtubeUrl)
        XCTAssertNil(recipe.photoUrlSmall)
        XCTAssertNil(recipe.photoUrlLarge)
    }
}
