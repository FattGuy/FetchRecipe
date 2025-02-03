//
//  AsyncImageView.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published private(set) var image: Image?
    
    private let url: URL?
    private var cache = ImageCache.shared
    private var task: Task<Void, Never>?
    
    init(url: URL?) {
        self.url = url
        load()  // Trigger image loading immediately
    }
    
    func load() {
        guard let url = url else { return }
        
        if let cachedImage = cache.loadImage(from: url) {
            self.image = Image(uiImage: cachedImage)
            return
        }
        
        task?.cancel()  // Cancel previous task
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    cache.saveImage(uiImage, for: url)
                    self.image = Image(uiImage: uiImage)
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    
    init(url: URL?) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
        }
    }
}
