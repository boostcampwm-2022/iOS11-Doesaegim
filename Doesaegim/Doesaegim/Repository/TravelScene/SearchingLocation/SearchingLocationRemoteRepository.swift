//
//  SearchingLocationRemoteRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/12/08.
//

import Foundation
import MapKit

final class SearchingLocationRemoteRepository: SearchingLocationRepository {
    private let request = MKLocalSearch.Request()
    
    func search(
        with keyword: String,
        completion: @escaping ((Result<[SearchResultCellViewModel], NetworkError>) -> Void)
    ) {
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(MKMapRect.world)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error {
                if let mkError = error as? MKError, mkError.code == .placemarkNotFound {
                    return completion(.success([]))
                }
                return completion(.failure(.invalidRequest))
            }
            
            guard let response
            else { return completion(.failure(.responseError)) }
            
            let cellViewModels = response.mapItems.map({
                let placemark = $0.placemark
                return SearchResultCellViewModel(
                    name: placemark.name ?? "",
                    address: (placemark.locality ?? "") + " " + (placemark.thoroughfare ?? ""),
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude
                )
            })
            
            completion(.success(cellViewModels))
        }
    }
}
