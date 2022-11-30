//
//  DiaryDetailViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

final class DiaryDetailViewModel {
    
    // MARK: - Properties
    
    weak var delegate: DiaryDetailViewModelDelegate?
    
    var imageCount: Int { diary.images?.count ?? 0 }
    
    var cellViewModels: [DetailImageCellViewModel] = [] {
        didSet {
            delegate?.diaryDetailImageSliderPagesDidFetch(cellViewModels.count)
            delegate?.diaryDetailImageSliderDidRefresh()
        }
    }
    
    private let navigationTitle: String?
    
    private let diary: Diary
    
    private let repository = DiaryDetailLocalRepository()
    
    // MARK: - Init
    
    // TODO: 이니셜라이징할 때 Result를 넘겨주는 방법..???을 모르겠어서 그냥 fail뜨면 nil처리되도록..
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
        delegate?.diaryDetailTitleDidFetch(with: navigationTitle)
        delegate?.diaryDetailDidFetch(diary: diary)
        
        guard let paths = diary.images,
              let diaryID = diary.id,
              let imageItems = repository.getImageDatas(from: paths, diaryID: diaryID)
        else { return }
        cellViewModels = imageItems.map { DetailImageCellViewModel(data: $0) }
    }
    
}
