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
        imageManager.image(withID: id) { [weak self] id in
            self?.delegate?.diaryAddViewModelDidLoadImage(withId: id)
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

    func saveButtonDidTap() {
        // Obtaining the Location of the Documents Directory
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let imageURLs = imageManager.selectedIDs.forEach {
            guard let image = imageManager.
        }
        // Create URL

        // Convert to Data
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
            }
        }
        /*
            1. 파일 시스템에 이미지를 모두 저장하고 경로 리턴
               - 하나라도 저장 실패 시 즉시 리턴하고 에러 리턴
            2. tempDiary와 이미지 경로들을 사용해서 DTO 생성
            3. 레포지토리를 통해 저장
            4. 레포지토리 저장 결과를 받아서 델리게이트에 전달
         */
        delegate?.diaryAddViewModelDidAddDiary(.failure(CoreDataError.saveFailure(.diary)))
    }
}
