//
//  ImageManager.swift
//  Doesaegim
//
//  Created by sun on 2022/11/24.
//

import UIKit

/// NSItemProvider와 NSCache를 사용해서 이미지 처리 및 관리
final class ImageManager {
    typealias ImageID = String

    // MARK: - Properties

    /// 유저가 선택한 이미지의 아이디
    var selectedIDs = [ImageID]()

    var itemProviders = [ImageID: NSItemProvider]()

    var images = [ImageID: UIImage]()


    // MARK: - Functions

    /// 해당 아이디의 이미지가 이미 처리된 적 있으면  불러오고, 없으면 itemProvider로부터 로딩해서 리턴
    func image(withID id: ImageID, completionHandler: @escaping (ImageID) -> Void) -> ImageStatus {
        if let image = images[id] {
            return .complete(image)
        }

        guard let itemProvider = itemProviders[id],
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            return .error(nil)
        }

        let progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            if let image = object as? UIImage {
                self?.images[id] = image
            }

            completionHandler(id)
        }

        return .inProgress(progress)
    }
}


// MARK: - Constants

fileprivate extension ImageManager {

    enum StringLiteral {
        static let errorImageName = "exclamationmark.circle"
    }
}
