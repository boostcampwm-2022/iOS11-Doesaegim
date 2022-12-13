//
//  UIImage+Downsample.swift
//  Doesaegim
//
//  Created by sun on 2022/12/12.
//

import UIKit

extension UIImage {

    enum DownsampleMode {
        case aspectFit
        case aspectFill
    }


    /// 다운샘플링된 이미지를 생성, 실패 시 nil 리턴
    /// - Parameters:
    ///   - data: 이미지 데이터
    ///   - size: 다운샘플링할 크기
    convenience init?(data: Data, size: CGSize, scale: CGFloat, mode: DownsampleMode = .aspectFill) {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, options),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, .zero, options) as? [CFString: Any],
              let pixelWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let pixelHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
              pixelWidth > .zero,
              pixelHeight > .zero
        else {
            return nil
        }

        var maxPixelSize = max(size.width, size.height) * scale
        if mode == .aspectFill {
            let heightWidthRatio = pixelHeight / pixelWidth
            let smallSide = min(size.width, size.height)
            let hasLongerHeight = heightWidthRatio > 1
            let width = hasLongerHeight ? smallSide : smallSide / heightWidthRatio
            let height = hasLongerHeight ? smallSide * heightWidthRatio : smallSide
            maxPixelSize = max(width, height) * scale
        }

        let thumbnailOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, .zero, thumbnailOptions)
        else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}
