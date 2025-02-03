//
//  Untitled.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let sourceUrl: URL?
    let youtubeUrl: URL?
    let photoUrlSmall: URL?
    let photoUrlLarge: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        
        // Gracefully handle invalid URLs
        sourceUrl = URL(string: (try? container.decode(String.self, forKey: .sourceUrl)) ?? "")
        youtubeUrl = URL(string: (try? container.decode(String.self, forKey: .youtubeUrl)) ?? "")
        photoUrlSmall = URL(string: (try? container.decode(String.self, forKey: .photoUrlSmall)) ?? "")
        photoUrlLarge = URL(string: (try? container.decode(String.self, forKey: .photoUrlLarge)) ?? "")
    }
}
