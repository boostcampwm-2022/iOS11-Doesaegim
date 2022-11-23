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

    private let imageStore = ImageStore()

    private let errorImage: UIImage


    // MARK: - Init(s)

    init(errorImage: UIImage = UIImage(systemName: StringLiteral.errorImageName) ?? UIImage()) {
        self.errorImage = errorImage
    }


    // MARK: - Functions

    /// 해당 아이디의 이미지가 이미 처리된 적 있으면 캐시에서 불러오고, 없으면 itemProvider로부터 로딩해서 리턴
    func image(withID id: ImageID, completionHandler: @escaping (ImageID) -> Void) -> ImageStatus {
        if let image = imageStore.image(usingKey: id), image != errorImage {
            return .complete(image)
        }

        guard let itemProvider = itemProviders[id],
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            return .complete(errorImage)
        }

        let progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            let image = object as? UIImage ?? self?.errorImage
            // TODO: RESIZING...
            self?.imageStore.saveImage(image ?? UIImage(), usingKey: id)
            DispatchQueue.main.async {
                completionHandler(id)
            }
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
