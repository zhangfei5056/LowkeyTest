//
//  CachedImageView.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/4/09.
//

import UIKit

class CachedImageView: UIImageView {
    // Shared image cache
    static let imageCache = NSCache<NSString, UIImage>()

    func loadImage(url: URL?) {
        guard let url = url else { return }

        // Check if the image is already in the cache
        if let cachedImage = CachedImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }

        // Image not in cache, download it
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("download image error：\(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data) {
                // Save the image to cache
                CachedImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
