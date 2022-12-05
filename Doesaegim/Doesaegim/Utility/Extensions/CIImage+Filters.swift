//
//  CIImage+Filters.swift
//  Doesaegim
//
//  Created by sun on 2022/12/01.
//

import UIKit

extension CIImage {

    /// 현재의 CIImage를 배경으로 해서 inputImage를 마스킹하여 덧붙임
    /// - Parameters:
    ///   - maskImage: 마스크 역할을 할 CIImage
    ///   - inputImage: 현재 이미지 위에 덧붙일 CIImage
    /// - Returns: CIImage?
    func blendWithMask(_ maskImage: CIImage, inputImage: CIImage) -> CIImage? {
        CIFilter(
            name: Filter.CIBlendWithMask.rawValue,
            parameters: [
                kCIInputImageKey: inputImage,
                kCIInputBackgroundImageKey: self,
                kCIInputMaskImageKey: maskImage
            ]
        )?.outputImage
    }

    /// 현재의 CIImage에 블러를 적용
    /// - Parameter radius: 블러 정도
    /// - Returns: CIImgae?
    func gaussianBlur(radius: CGFloat = 20) -> CIImage? {
        CIFilter(
            name: Filter.CIGaussianBlur.rawValue,
            parameters: [
                kCIInputImageKey: self,
                kCIInputRadiusKey: radius
            ]
        )?.outputImage
    }


    /// 인자로 받은 CGRect 영역에 RadialGradient의 형태로 마스크를 생성
    /// - Parameter areas: 마스킹할 영역을 담은 CGRect 배열
    /// - Returns: CIImage?
    func maskAreas(_ areas: [CGRect]) -> CIImage? {
        var maskImage = CIImage?.none

        areas.forEach {
            let size = $0.size
            let centerX = $0.origin.x + size.width / 2
            let centerY = (extent.height - $0.maxY) + size.height / 2
            let radius: CGFloat = min(size.width, size.height) / 2.4

            let radialImage = CIFilter(
                name: Filter.CIRadialGradient.rawValue,
                parameters: [
                    kCIInputCenterKey: CIVector(x: centerX, y: centerY),
                    FilterParameter.inputRadius0.rawValue: NSNumber(value: radius),
                    FilterParameter.inputRadius1.rawValue: NSNumber(value: radius + 1),
                    FilterParameter.inputColor0.rawValue: CIColor(red: .zero, green: 1, blue: 0, alpha: 1),
                    FilterParameter.inputColor1.rawValue: CIColor(color: .clear)
                ]
            )?.outputImage

            guard let backgroundImage = maskImage,
                  let radialImage
            else {
                maskImage = radialImage
                return
            }

            maskImage = CIFilter(
                name: Filter.CISourceOverCompositing.rawValue,
                parameters: [
                    kCIInputImageKey: radialImage,
                    kCIInputBackgroundImageKey: backgroundImage
                ]
            )?.outputImage
        }

        return maskImage
    }

    /// 이미지를 픽셀화
    /// - Parameter scale: 픽셀 크기
    /// - Returns: CIImage
    func pixelate(scale: Int? = nil) -> CIImage? {
        CIFilter(
            name: Filter.CIPixellate.rawValue,
            parameters: [
                kCIInputImageKey: self,
                kCIInputScaleKey: scale ?? min(extent.width, extent.height) / 40
            ]
        )?.outputImage
    }
}


// MARK: - Constants

fileprivate extension CIImage {

    /// 필터 종류
    private enum Filter: String {
        case CIGaussianBlur
        case CIMaskedVariableBlur
        case CIPixellate
        case CIRadialGradient
        case CISourceOverCompositing
        case CIBlendWithMask
    }

    private enum FilterParameter: String {
        case inputRadius0
        case inputRadius1
        case inputColor0
        case inputColor1
    }
}
