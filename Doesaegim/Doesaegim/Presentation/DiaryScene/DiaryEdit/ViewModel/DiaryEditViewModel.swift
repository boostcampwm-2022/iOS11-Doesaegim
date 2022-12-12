//
//  DiaryEditViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/12/12.
//

import UIKit

final class DiaryEditViewModel {
    typealias ImageID = String

    // MARK: - Properties

    weak var delegate: DiaryEditViewModelDelegate?

    var dateInterval: DateInterval? {
        guard let travel = temporaryDiary.travel,
              let startDate = travel.startDate,
              let endDate = travel.endDate
        else {
            return nil
        }

        return DateInterval(start: startDate, end: endDate)
    }

    var selectedImageIDs: [ImageID] {
        imageManager.selectedIDs
    }

    lazy var travelPickerDataSource: PickerDataSource<Travel> = {
        let result = repository.fetchAllTravels()

        switch result {
        case .success(let travels):
            return PickerDataSource(items: travels)
        case .failure(let error):
            return PickerDataSource(items: [])
        }
    }()

    /// 유저의 입력값을 관리하기 위한 객체
    private(set) var temporaryDiary = TemporaryDiary()

    private let repository: DiaryEditRepository

    private let imageManager: ImageManager

    private let diary: Diary


    // MARK: - Init(s)

    init(diary: Diary, repository: DiaryEditRepository, imageManager: ImageManager, images: [UIImage?]) {
        self.repository = repository
        self.imageManager = imageManager
        self.diary = diary
        guard let imageIDs = diary.images
        else {
            return
        }

        zip(imageIDs, images).forEach { id, image in
            self.imageManager.selectedIDs.append(id)

            guard let image
            else {
                return
            }
            self.imageManager.images[id] = image
        }
    }


    // MARK: - User Interaction Handling Functions

    func viewDidLoad() {
        temporaryDiary.date = diary.date
        temporaryDiary.travel = diary.travel
        if let location = diary.location {
            temporaryDiary.location = LocationDTO(
                name: location.name ?? .empty,
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        temporaryDiary.title = diary.title
        temporaryDiary.content = diary.content
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
        delegate?.diaryEditViewModelDidUpdateSelectedImageIDs(selectedImageIDs)
    }

    func travelDidSelect(_ travel: Travel) {
        temporaryDiary.travel = travel
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
    }

    func locationDidSelect(_ location: LocationDTO) {
        temporaryDiary.location = location
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
    }

    func dateDidSelect(_ date: Date) {
        temporaryDiary.date = date
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
    }

    func titleDidChange(to title: String?) {
        temporaryDiary.title = title
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
    }

    func contentDidChange(to content: String?) {
        temporaryDiary.content = content
        delegate?.diaryEditViewModelValuesDidChange(temporaryDiary)
    }

    func image(withID id: ImageID) -> ImageStatus {
        guard id != .empty
        else {
            return .dummy
        }

        let status = imageManager.image(withID: id) { [weak self] id in
            DispatchQueue.main.async {
                self?.delegate?.diaryEditViewModelDidLoadImage(withID: id)
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
        results.forEach {
            guard !imageManager.selectedIDs.contains($0.id)
            else {
                return
            }
            imageManager.selectedIDs.append($0.id)
            imageManager.itemProviders[$0.id] = $0.itemProvider
        }
        let selectedIDs = imageManager.selectedIDs
        let snapshotIDs = selectedIDs + (selectedIDs.count == Metric.numberOfMaximumPhotos ? [] : [.empty] )
        delegate?.diaryEditViewModelDidUpdateSelectedImageIDs(snapshotIDs)
    }

    func removeImage(withID id: ImageID) {
        imageManager.selectedIDs.removeAll { $0 == id }
        imageManager.itemProviders[id] = nil
        delegate?.diaryEditViewModelDidRemoveImage(withID: id)
    }

    func saveButtonDidTap() {
        let imageDeletingGroup = DispatchGroup()
        deleteDeselectedImagesInFileSystem(dispatchGroup: imageDeletingGroup)
        imageDeletingGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            self?.save()
        }
    }

    private func save() {
        temporaryDiary.imagePaths = Array(repeating: .empty, count: imageManager.selectedIDs.count)
        let imageSavingGroup = DispatchGroup()

        saveImagesToFileSystem(groupedBy: imageSavingGroup)

        imageSavingGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let imagePaths = self?.temporaryDiary.imagePaths,
                  !imagePaths.contains(.empty)
            else {
                self?.deleteImagesInFileSystem()
                DispatchQueue.main.async {
                    self?.delegate?.diaryEditViewModelDidSaveDiary(
                        .failure(CoreDataError.saveFailure(.diary))
                    )
                }
                return
            }

            guard let result = self?.saveDiary()
            else {
                return
            }

            switch result {
            case .success:
                break
            case .failure:
                self?.deleteImagesInFileSystem()
            }

            DispatchQueue.main.async {
                self?.delegate?.diaryEditViewModelDidSaveDiary(result)
            }
        }
    }

    private func saveImagesToFileSystem(groupedBy imageSavingGroup: DispatchGroup) {
        imageManager.selectedIDs.enumerated().forEach { index, imageID in
            let imageConvertingGroup = DispatchGroup()
            imageConvertingGroup.enter()
            imageSavingGroup.enter()

            let convertingWorkitem = DispatchWorkItem { [weak self] in
                let result = self?.imageManager.image(withID: imageID) { _ in
                    imageConvertingGroup.leave()
                }

                switch result {
                case .complete, .error:
                    imageConvertingGroup.leave()
                default:
                    break
                }
            }

            let savingWorkItem = DispatchWorkItem { [weak self] in
                guard let image = self?.imageManager.images[imageID],
                      let diaryID = self?.diary.id,
                      FileProcessManager.shared.saveImage(image, imageID: imageID, diaryID: diaryID) == true,
                      let range = self?.temporaryDiary.imagePaths.indices,
                      range ~= index
                else {
                    self?.temporaryDiary.imagePaths[index] = .empty
                    imageSavingGroup.leave()
                    return
                }

                self?.temporaryDiary.imagePaths[index] = imageID
                imageSavingGroup.leave()
            }

            imageConvertingGroup.notify(queue: .global(qos: .userInitiated), work: savingWorkItem)
            DispatchQueue.global(qos: .userInitiated).async(execute: convertingWorkitem)
        }
    }

    private func saveDiary() -> Result<Bool, Error> {
        guard let title = temporaryDiary.title,
              let content = temporaryDiary.content,
              let location = temporaryDiary.location,
              let travel = temporaryDiary.travel,
              let previousTravel = diary.travel,
              let date = temporaryDiary.date
        else {
            return .failure(CoreDataError.saveFailure(.diary))
        }

        if travel != previousTravel {
            previousTravel.removeFromDiary(diary)
            travel.addToDiary(diary)
        }
        diary.title = title
        diary.date = date
        diary.content = content
        diary.location?.name = location.name
        diary.location?.latitude = location.latitude
        diary.location?.longitude = location.longitude
        diary.images = temporaryDiary.imagePaths

        return repository.saveDiary()
    }

    private func deleteImagesInFileSystem() {
        guard let diaryID = diary.id
        else {
            return
        }

        let group = DispatchGroup()
        temporaryDiary.imagePaths.filter { !$0.isEmpty }.forEach { id in
            group.enter()
            DispatchQueue.global().async {
                /// 삭제에 실패하면 한 번 더 시도 후 리턴
                // TODO: 다른 방법이 있을까...?
                if !FileProcessManager.shared.deleteImage(at: id, diaryID: diaryID) {
                    FileProcessManager.shared.deleteImage(at: id, diaryID: diaryID)
                }
                group.leave()
            }
        }

        group.wait()
    }

    private func deleteDeselectedImagesInFileSystem(dispatchGroup group: DispatchGroup) {
        guard let diaryID = diary.id
        else {
            return
        }

        diary.images?.filter { !self.selectedImageIDs.contains($0) }.forEach { id in
            group.enter()
            DispatchQueue.global().async {
                /// 삭제에 실패하면 한 번 더 시도 후 리턴
                // TODO: 다른 방법이 있을까...?
                if !FileProcessManager.shared.deleteImage(at: id, diaryID: diaryID) {
                    FileProcessManager.shared.deleteImage(at: id, diaryID: diaryID)
                }
                group.leave()
            }
        }
    }
}


// MARK: - Constants

fileprivate extension DiaryEditViewModel {

    enum StringLiteral {
        static let errorImageName = "exclamationmark.circle"
    }

    enum Metric {
        static let numberOfMaximumPhotos = 5
    }
}
