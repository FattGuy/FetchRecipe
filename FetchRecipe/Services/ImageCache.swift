//
//  ImageCache.swift
//  FetchRecipe
//
//  Created by Feng Chang on 2/3/25.
//

import Foundation
import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        cache.countLimit = 100  // Cache up to 100 images
        cache.totalCostLimit = 50 * 1024 * 1024  // 50MB memory limit

        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func loadImage(from url: URL) -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }

        let filePath = cacheDirectory.appendingPathComponent(url.absoluteString.hashValue.description)
        if let data = try? Data(contentsOf: filePath), let image = UIImage(data: data) {
            cache.setObject(image, forKey: url as NSURL, cost: data.count)  // Store using cost-based cache
            return image
        }

        return nil
    }

    func saveImage(_ image: UIImage, for url: URL) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        cache.setObject(image, forKey: url as NSURL, cost: data.count)  // ✅ Store based on memory cost

        let hashedFileName = "\(url.absoluteString.hashValue).jpg"
        let filePath = cacheDirectory.appendingPathComponent(hashedFileName)

        try? data.write(to: filePath)
    }
}
