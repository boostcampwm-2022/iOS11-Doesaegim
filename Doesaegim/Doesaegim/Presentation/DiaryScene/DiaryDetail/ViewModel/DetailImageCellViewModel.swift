//
//  DetailImageCellViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

final class DetailImageCellViewModel: Hashable {
    
    // MARK: - Properties
    
    private let id = UUID()
    
    /// 이미지 데이터
    let data: Data
    
    // MARK: - Init

    init(data: Data) {
        self.data = data
    }
    
    // MARK: - Functions
    
    static func == (lhs: DetailImageCellViewModel, rhs: DetailImageCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
