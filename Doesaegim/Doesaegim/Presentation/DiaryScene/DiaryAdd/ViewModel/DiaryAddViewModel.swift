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

    private let repository: DiaryAddRepository

    private let imageManager: ImageManager


    // MARK: - Init(s)

    init(repository: DiaryAddRepository, imageManager: ImageManager) {
        self.repository = repository
        self.imageManager = imageManager
    }


    // MARK: - User Interaction Handling Functions

    func travelDidSelect(_ travel: Travel) {
        temporaryDiary.travel = travel
        if let date = temporaryDiary.date,
           let startDate = travel.startDate,
           let endDate = travel.endDate,
           let dateAfterEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate),
           !(startDate..<dateAfterEndDate ~= date) {
            /// 여행 변경 후 기존에 설정한 날짜가 여행의 기간을 벗어나는 경우 무효화
            temporaryDiary.date = nil
        }
        delegate?.diaryAddViewModelValuesDidChange(temporaryDiary)
    }

    func locationDidSelect(_ location: LocationDTO) {
        temporaryDiary.location = location
        delegate?.diaryAddViewModelValuesDidChange(temporaryDiary)
    }

    func dateDidSelect(_ date: Date) {
        temporaryDiary.date = date
        delegate?.diaryAddViewModelValuesDidChange(temporaryDiary)
    }

    func titleDidChange(to title: String?) {
        temporaryDiary.title = title
        delegate?.diaryAddViewModelValuesDidChange(temporaryDiary)
    }

    func contentDidChange(to content: String?) {
        temporaryDiary.content = content
        delegate?.diaryAddViewModelValuesDidChange(temporaryDiary)
    }

    func image(withID id: ImageID) -> ImageStatus {
        guard id != .empty
        else {
            return .dummy
        }

        let status = imageManager.image(withID: id) { [weak self] id in
            DispatchQueue.main.async {
                self?.delegate?.diaryAddViewModelDidLoadImage(withID: id)
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
        delegate?.diaryAddViewModelDidUpdateSelectedImageIDs(snapshotIDs)
    }

    func removeImage(withID id: ImageID) {
        imageManager.selectedIDs.removeAll { $0 == id }
        imageManager.itemProviders[id] = nil
        delegate?.diaryAddViewModelDidRemoveImage(withID: id)
    }

    func saveButtonDidTap() {
        temporaryDiary.imagePaths = Array(repeating: .empty, count: imageManager.selectedIDs.count)
        let imageSavingGroup = DispatchGroup()
        saveImagesToFileSystem(groupedBy: imageSavingGroup)

        imageSavingGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let imagePaths = self?.temporaryDiary.imagePaths,
                  !imagePaths.contains(.empty)
            else {
                self?.deleteImagesInFileSystem()
                DispatchQueue.main.async {
                    self?.delegate?.diaryAddViewModelDidAddDiary(.failure(CoreDataError.saveFailure(.diary)))
                }
                return
            }

            guard let result = self?.addDiary()
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
                self?.delegate?.diaryAddViewModelDidAddDiary(result)
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
                      let diaryID = self?.temporaryDiary.id,
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

    private func addDiary() -> Result<Diary, Error> {
        guard let title = temporaryDiary.title,
              let content = temporaryDiary.content,
              let travel = temporaryDiary.travel,
              let date = temporaryDiary.date
        else {
            return .failure(CoreDataError.saveFailure(.diary))
        }

        let diaryDTO = DiaryDTO(
            id: temporaryDiary.id,
            content: content,
            date: date,
            images: temporaryDiary.imagePaths,
            title: title,
            location: temporaryDiary.location,
            travel: travel
        )

        return repository.addDiary(diaryDTO)
    }

    private func deleteImagesInFileSystem() {
        let group = DispatchGroup()

        temporaryDiary.imagePaths.filter { !$0.isEmpty }.forEach { id in
            group.enter()
            DispatchQueue.global().async {
                /// 삭제에 실패하면 한 번 더 시도 후 리턴
                // TODO: 다른 방법이 있을까...?
                if !FileProcessManager.shared.deleteImage(at: id, diaryID: self.temporaryDiary.id) {
                    FileProcessManager.shared.deleteImage(at: id, diaryID: self.temporaryDiary.id)
                }
                group.leave()
            }
        }

        group.wait()
    }
}


// MARK: - Constants

fileprivate extension DiaryAddViewModel {

    enum StringLiteral {
        static let errorImageName = "exclamationmark.circle"
    }

    enum Metric {
        static let numberOfMaximumPhotos = 5
    }
}
