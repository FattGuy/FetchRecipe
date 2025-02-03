//
//  ImageCacheTests.swift
//  FetchRecipeTests
//
//  Created by Feng Chang on 2/3/25.
//

import XCTest
@testable import FetchRecipe

class ImageCacheTests: XCTestCase {
    var cache: ImageCache!

    override func setUp() {
        super.setUp()
        cache = ImageCache.shared
    }

    func testImageCacheStoresImage() {
        let testURL = URL(string: "https://example.com/image.jpg")!
        let testImage = UIImage(systemName: "star.fill")!

        cache.saveImage(testImage, for: testURL)

        let retrievedImage = cache.loadImage(from: testURL)
        XCTAssertNotNil(retrievedImage)
    }
}
