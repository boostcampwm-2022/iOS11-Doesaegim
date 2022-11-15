//
//  SearchingLocationViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import Foundation

final class SearchingLocationViewModel {
    
    // MARK: - Properties
    
    weak var delegate: SearchingLocationViewControllerDelegate?
    
    var searchResultCellViewModels: [SearchResultCellViewModel] = [] {
        didSet {
            delegate?.refreshSnapshot()
        }
    }
    
    // MARK: - Functions
    
    // TODO: 더미 데이터 설정. 추후 삭제
    func fetchDummies() {
        let dummies = [
            SearchResultCellViewModel(
                name: "1. 네이버 1784",
                address: "경기 성남시 분당구",
                latitude: 0.0,
                longitude: 0.0
            ),
            SearchResultCellViewModel(
                name: "2. 네이버 1784", 
                address: "경기 성남시 분당구",
                latitude: 0.0,
                longitude: 0.0
            ),
            SearchResultCellViewModel(
                name: "3. 네이버 1784",
                address: "경기 성남시 분당구",
                latitude: 0.0,
                longitude: 0.0
            ),
            SearchResultCellViewModel(
                name: "4. 네이버 1784",
                address: "경기 성남시 분당구",
                latitude: 0.0,
                longitude: 0.0
            ),
            SearchResultCellViewModel(
                name: "5. 네이버 1784",
                address: "경기 성남시 분당구",
                latitude: 0.0,
                longitude: 0.0
            )
        ]
        
        searchResultCellViewModels = dummies
    }
    
    func fetchSearchResults(with keyword: String) {
        
    }
}
