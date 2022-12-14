//
//  ImageCacheManager.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/06.
//

import UIKit


final class ImageCacheManager {
    
    static let shared = NSCache<NSString, NSData>()
    
    private init() {  }
}

// MARK: - Image

extension ImageCacheManager {
    
    static func loadImage(with path: String) -> Result<Data, Error> {
        let cacheKey = NSString(string: path)
        guard let cacheData = ImageCacheManager.shared.object(forKey: cacheKey) else {
            return .failure(CacheError.canNotFindImageError)
        }
        let cacheImageData = Data(referencing: cacheData)
        return .success(cacheImageData)
    }
    
    static func addImage(with path: String, data: Data) {
        let imageData = NSData(data: data)
        ImageCacheManager.shared.setObject(imageData, forKey: NSString(string: path))
    }
    
}

enum CacheError: LocalizedError {
    case canNotFindImageError
    case canNotFindImageURLFromPathString
    
    var errorDescription: String? {
        switch self {
        case .canNotFindImageError:
            return "이미지가 캐시에 존재하지 않습니다."
        case .canNotFindImageURLFromPathString:
            return "잘못된 이미지경로 URL 형식입니다."
        }
    }
}
