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
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let image = self?.image,
                  let ciImage = CIImage(image: image),
                  let blurredImage = ciImage.gaussianBlur(),
                  let selectedFaceRects = self?.selectedFaceRects,
                  let maskImage = ciImage.maskAreas(selectedFaceRects),
                  let blendedImage = ciImage.blendWithMask(maskImage, inputImage: blurredImage),
                  let cgImage = BlurredImageViewModel.context.createCGImage(
                    blendedImage,
                    from: blendedImage.extent
                  )
            else {
                DispatchQueue.main.async { [weak self] in
                    let errorImage = UIImage(systemName: StringLiteral.errorImageName)
                    self?.blurCompletionHandler?(self?.image ?? errorImage)
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.blurCompletionHandler?(UIImage(cgImage: cgImage))
            }
        }
    }
}


// MARK: - Constants
fileprivate extension BlurredImageViewModel {

    enum StringLiteral {
        static let errorImageName = "questionmark.circle"
    }
}
