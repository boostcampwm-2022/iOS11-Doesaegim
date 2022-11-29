//
//  DiaryAddViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import UIKit

final class DiaryAddViewModel {
    typealias ImageID = String

    // MARK: - Properties

    weak var delegate: DiaryAddViewModelDelegate?

    lazy var travelPickerDataSource: PickerDataSource<Travel> = {
        let result = repository.fetchAllTravels()

        switch result {
        case .success(let travels):
            return PickerDataSource(items: travels)
        case .failure(let error):
            return PickerDataSource(items: [])
        }
    }()

    private let repository: DiaryAddRepository

    private let imageManager: ImageManager

    /// 유저의 입력값을 관리하기 위한 객체
    private var temporaryDiary = TemporaryDiary()


    // MARK: - Init(s)

    init(repository: DiaryAddRepository, imageManager: ImageManager) {
        self.repository = repository
        self.imageManager = imageManager
    }


    // MARK: - User Interaction Handling Functions

    func travelDidSelect(_ travel: Travel) {
        temporaryDiary.travel = travel
        delegate?.diaryAddViewModlelValuesDidChange(temporaryDiary)
    }

    func locationDidSelect(_ location: LocationDTO) {
        temporaryDiary.location = location
        delegate?.diaryAddViewModlelValuesDidChange(temporaryDiary)
    }

    func titleDidChange(to title: String?) {
        temporaryDiary.title = title
        delegate?.diaryAddViewModlelValuesDidChange(temporaryDiary)
    }

    func contentDidChange(to content: String?) {
        temporaryDiary.content = content
        delegate?.diaryAddViewModlelValuesDidChange(temporaryDiary)
    }

    func image(withID id: ImageID) -> ImageStatus {
        let status = imageManager.image(withID: id) { [weak self] id in
            DispatchQueue.main.async {
                self?.delegate?.diaryAddViewModelDidLoadImage(withId: id)
            }
        }

        switch status {
        case .error(let image):
            return .error(image ?? UIImage(systemName: StringLiteral.errorImageName))
        default:
            return status
        }
    }

    func imageDidSelect(_ results: [(id: ImageID, itemProvider: NSItemProvider)]) {
        imageManager.selectedIDs.removeAll()
        imageManager.itemProviders.removeAll()

        results.forEach {
            imageManager.selectedIDs.append($0.id)
            imageManager.itemProviders[$0.id] = $0.itemProvider
        }

        delegate?.diaryAddViewModelDidUpdateSelectedImageIDs(imageManager.selectedIDs)
    }
}


// MARK: - Constants

fileprivate extension DiaryAddViewModel {

    enum StringLiteral {
        static let errorImageName = "exclamationmark.circle"
    }
}
