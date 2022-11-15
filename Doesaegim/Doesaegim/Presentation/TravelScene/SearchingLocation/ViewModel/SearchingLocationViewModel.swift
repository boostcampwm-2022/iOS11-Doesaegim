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
    
    weak var delegate: SearchingLocationViewControllerDelegate?
    
    var searchResultCellViewModels: [SearchResultCellViewModel] = [] {
        didSet {
            delegate?.refreshSnapshot()
        }
    }
    
    // MARK: - Functions
    
    /// 키워드를 통해 장소를 검색하고, 검색 결과값을 `searchResultCellViewModels`에 저장한다.
    /// - Parameter keyword: 입력된 키워드
    func fetchSearchResults(with keyword: String) {
        // TODO: MKMapView 인스턴스를 생성만 하면 현재 위치 정보도 여기에 포함되는 걸까..? 아니라면 사용자의 현재 위치에 맞는 검색 결과를 보여주도록 수정 필요..
        let mapView = MKMapView()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            let mapItems = response.mapItems.map({
                let placemark = $0.placemark
                return SearchResultCellViewModel(
                    name: placemark.name ?? "",
                    address: (placemark.locality ?? "") + " " + (placemark.thoroughfare ?? ""),
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude
                )
            })
            mapView.removeAnnotations(mapView.annotations)
            // [Memory] Resetting zone allocator with 32387 allocations still alive 경고가 떠서 추가
            // removeAnnotations과 어떤 관련이 있는지는 아직 정확히 파악하지 못함..
            
            self.searchResultCellViewModels = mapItems
        }
    }
}
