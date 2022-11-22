//
//  DiaryAddViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import Foundation

final class DiaryAddViewModel {

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

    /// 유저의 입력값을 관리하기 위한 객체
    private var temporaryDiary = TemporaryDiary()


    // MARK: - Init(s)

    init(repository: DiaryAddRepository) {
        self.repository = repository
    }


    // MARK: - User Interaction Handling Functions

    func travelDidSelect(_ travel: Travel) {
        temporaryDiary.travel = travel
        delegate?.diaryValuesDidChange(temporaryDiary)
    }

    func locationDidSelect(_ location: LocationDTO) {
        temporaryDiary.location = location
        delegate?.diaryValuesDidChange(temporaryDiary)
    }

    func titleDidChange(to title: String?) {
        temporaryDiary.title = title
        delegate?.diaryValuesDidChange(temporaryDiary)
    }
    
    func contentDidChange(to content: String?) {
        temporaryDiary.content = content
        delegate?.diaryValuesDidChange(temporaryDiary)
    }
}
