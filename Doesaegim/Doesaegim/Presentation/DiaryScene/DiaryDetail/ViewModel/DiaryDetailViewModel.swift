//
//  DiaryDetailViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

final class DiaryDetailViewModel {
    
    // MARK: - Properties
    
    let diary: Diary

    weak var delegate: DiaryDetailViewModelDelegate?

    var imageCount: Int { diary.images?.count ?? 0 }

    var cellViewModels: [DetailImageCellViewModel] = [] {
        didSet {
            delegate?.diaryDetailImageSliderPagesDidFetch(cellViewModels.count)
            delegate?.diaryDetailImageSliderDidRefresh()
        }
    }

    private let navigationTitle: String?

    
    private let repository = DiaryDetailLocalRepository()
    
    // MARK: - Init
    
    init?(id: UUID) {
        let result = repository.getDiaryDetail(with: id)
        switch result {
        case .success(let diary):
            self.diary = diary
            self.navigationTitle = diary.title
        case .failure:
            return nil
        }
    }
    
    init(diary: Diary) {
        self.diary = diary
        self.navigationTitle = diary.title
    }
    
    // MARK: - Functions
    
    func fetchDiaryDetail() {
        delegate?.diaryDetailDidFetch(diary: diary)
        
        guard let paths = diary.images,
              let diaryID = diary.id,
              let imageItems = repository.getImageDatas(from: paths, diaryID: diaryID)
        else { return }
        cellViewModels = imageItems.map { DetailImageCellViewModel(data: $0) }
    }
    
    func deleteDiary(with id: UUID) {
        
        let result = PersistentRepository.shared.fetchDiary()
        switch result {
        case .success(let diaries):
            let deleteDiary = diaries.filter { $0.id == id }
            guard let deleteObject = deleteDiary.last else { return }
            
            let deleteResult = PersistentManager.shared.delete(deleteObject)
            switch deleteResult {
            case .success(let isDeleteComplete):
                if isDeleteComplete {
                    delegate?.diaryDeleteDidComplete()
                }
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: - 삭제실패 알림 delegate
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            
        }
        
    }
    
}
