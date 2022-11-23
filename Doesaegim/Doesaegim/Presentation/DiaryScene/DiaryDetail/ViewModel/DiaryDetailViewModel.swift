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
    
    private let navigationTitle: String?
    
    private let diary: Diary
    
    private var currentPage = 0 {
        didSet {
            delegate?.pageControlValueDidChange(to: currentPage)
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
        delegate?.fetchNavigationTItle(with: navigationTitle)
        delegate?.fetchDiaryDetail(diary: diary)
        
        guard let paths = diary.images,
              let imageItems = repository.getImageDatas(from: paths)
        else { return }
        delegate?.fetchImageData(with: imageItems)
    }
    
    func currentPageDidChange(to page: Int) {
        currentPage = page
    }
}
