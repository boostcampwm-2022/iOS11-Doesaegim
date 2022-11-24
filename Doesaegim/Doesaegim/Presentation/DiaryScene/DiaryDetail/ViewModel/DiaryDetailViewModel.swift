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
    
    private var currentPage = 0 {
        didSet {
            delegate?.diaryDetailCurrentPageDidChange(to: currentPage)
        }
    }
    
    private let repository = DiaryDetailLocalRepository()
    
    // MARK: - Init
    
    init(diary: Diary) {
        self.diary = diary
        self.navigationTitle = diary.title
    }
    
    // MARK: - Functions
    
    func fetchDiaryDetail() {
        delegate?.diaryDetailTitleDidFetch(with: navigationTitle)
        delegate?.diaryDetailDidFetch(diary: diary)
        
        guard let paths = diary.images,
              let imageItems = repository.getImageDatas(from: paths)
        else { return }
        cellViewModels = imageItems.map { DetailImageCellViewModel(data: $0) }
    }
    
    func currentPageDidChange(to page: Int) {
        currentPage = page
    }
}
