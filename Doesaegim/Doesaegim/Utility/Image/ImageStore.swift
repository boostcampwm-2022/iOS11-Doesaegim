//
//  ImageStore.swift
//  Doesaegim
//
//  Created by sun on 2022/11/24.
//

import UIKit

/// 이미지 캐시를 관리
final class ImageStore {

    // MARK: - Properties

    /// 싱글턴 imageStore
    private static let shared = ImageStore()

    private let cache: NSCache = {
        let cache = NSCache<NSString, UIImage>()
        // TODO: Set Limit

        return cache
    }()


    // MARK: - Functions

    func saveImage(_ image: UIImage, usingKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func image(usingKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func removeImage(usingKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
