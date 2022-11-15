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
            
            self.searchResultCellViewModels = mapItems
        }
    }
}
