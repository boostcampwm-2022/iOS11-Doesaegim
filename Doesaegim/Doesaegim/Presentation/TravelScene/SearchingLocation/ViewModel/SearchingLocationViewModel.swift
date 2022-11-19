//
//  SearchingLocationViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import Foundation
import MapKit

final class SearchingLocationViewModel {
    
    // MARK: - Properties
    
    weak var delegate: SearchingLocationViewModelDelegate?
    
    private(set) var searchResultCellViewModels: [SearchResultCellViewModel] = [] {
        didSet {
            delegate?.searchLocaitonResultDidChange()
            delegate?.searchLocationSnapshotDidRefresh()
        }
    }
    
    // MARK: - Functions
    
    /// 키워드를 통해 장소를 검색하고, 검색 결과값을 `searchResultCellViewModels`에 저장한다.
    /// - Parameter keyword: 입력된 키워드
    func fetchSearchResults(with keyword: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(MKMapRect.world)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil
            else {
                // TODO: 에러 처리 필요
                self.searchResultCellViewModels = []
                return
            }
            
            let cellViewModels = response.mapItems.map({
                let placemark = $0.placemark
                return SearchResultCellViewModel(
                    name: placemark.name ?? "",
                    address: (placemark.locality ?? "") + " " + (placemark.thoroughfare ?? ""),
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude
                )
            })
            
            self.searchResultCellViewModels = cellViewModels
        }
    }
}
