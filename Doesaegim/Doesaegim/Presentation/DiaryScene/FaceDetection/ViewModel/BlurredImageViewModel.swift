//
//  BlurredImageViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/12/01.
//

import UIKit

final class BlurredImageViewModel {

    // MARK: - Properties

    private static let context = CIContext()

    var blurCompletionHandler: ((UIImage?) -> Void)?

    private let image: UIImage

    private let selectedFaceRects: [CGRect]


    // MARK: - Init

    init(image: UIImage, selectedFaceRects: [CGRect]) {
        self.image = image
        self.selectedFaceRects = selectedFaceRects
    }


    // MARK: Functions

    func applyFilter() {
        guard let ciImage = CIImage(image: image),
              let blurredImage = ciImage.gaussianBlur(),
              let maskImage = ciImage.maskAreas(selectedFaceRects),
              let blendedImage = ciImage.blendWithMask(maskImage, inputImage: blurredImage),
              let cgImage = BlurredImageViewModel.context.createCGImage(
                blendedImage,
                from: blendedImage.extent
              )
        else {
            blurCompletionHandler?(image)
            return
        }

        blurCompletionHandler?(UIImage(cgImage: cgImage))
    }
}
