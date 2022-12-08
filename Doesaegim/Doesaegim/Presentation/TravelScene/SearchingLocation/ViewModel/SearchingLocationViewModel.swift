//
//  SearchingLocationViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import Foundation

final class SearchingLocationViewModel {
    
    // MARK: - Properties
    
    private let repository: SearchingLocationRepository
    
    weak var delegate: SearchingLocationViewModelDelegate?
    
    private(set) var searchResultCellViewModels: [SearchResultCellViewModel] = [] {
        didSet {
            delegate?.searchLocaitonResultDidChange()
            delegate?.searchLocationSnapshotDidRefresh()
        }
    }
    
    // MARK: - Init
    
    init() {
        repository = SearchingLocationRemoteRepository()
    }
    
    // MARK: - Functions
    
    /// 키워드를 통해 장소를 검색하고, 검색 결과값을 `searchResultCellViewModels`에 저장한다.
    /// - Parameter keyword: 입력된 키워드
    func fetchSearchResults(with keyword: String) {
        delegate?.searchLocationWillStart()
        Task {
            let result = await repository.search(with: keyword)
            
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let cellViewModels):
                    self?.searchResultCellViewModels = cellViewModels
                case .failure(let error):
                    self?.searchResultCellViewModels = []
                    self?.delegate?.searchLocationErrorOccurred()
                    print(error.localizedDescription)
                }
            }
        }
    }
}
