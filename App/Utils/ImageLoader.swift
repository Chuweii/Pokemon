//
//  ImageLoader.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
    }

    func loadImage(from urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil) {
        imageView.image = placeholder

        // Check cache first
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            imageView.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    // Cache the image
                    self.cache.setObject(image, forKey: urlString as NSString)

                    // Update UI on main thread
                    await MainActor.run {
                        imageView.image = image
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
