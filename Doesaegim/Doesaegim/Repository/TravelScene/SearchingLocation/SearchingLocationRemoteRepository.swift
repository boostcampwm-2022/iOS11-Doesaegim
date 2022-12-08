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
    
    func search(with keyword: String) async -> Result<[SearchResultCellViewModel], NetworkError> {
        request.naturalLanguageQuery = keyword
        request.region = MKCoordinateRegion(MKMapRect.world)
        
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            let cellViewModels = response.mapItems.map({
                let placemark = $0.placemark
                return SearchResultCellViewModel(
                    name: placemark.name ?? "",
                    address: (placemark.locality ?? "") + " " + (placemark.thoroughfare ?? ""),
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude
                )
            })
            
            return .success(cellViewModels)
        } catch {
            return .failure(NetworkError.responseError)
        }
    }
}
