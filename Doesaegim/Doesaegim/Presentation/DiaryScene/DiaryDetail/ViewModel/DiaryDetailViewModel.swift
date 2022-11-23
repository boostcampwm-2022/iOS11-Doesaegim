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
    
    private let navigationTitle: String?
    
    private let diary: Diary
    
    // MARK: - Init
    
    init(diary: Diary) {
        self.diary = diary
        self.navigationTitle = diary.title
    }
    
    // MARK: - Functions
    
    func fetchDiaryDetail() {
        // TODO: FileManager를 통해 이미지 경로를 UIImage로 받아오는 작업 구현 필요 -> Repository 패턴 활용
        
        delegate?.fetchNavigationTItle(with: navigationTitle)
        delegate?.fetchDiaryDetail(diary: diary)
    }
}
