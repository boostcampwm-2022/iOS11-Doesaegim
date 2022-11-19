//
//  SearchResultCellViewModel.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import Foundation

final class SearchResultCellViewModel: Hashable {
    
    // MARK: - Properties
    
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    
    // MARK: - Init

    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Functions
    
    static func == (lhs: SearchResultCellViewModel, rhs: SearchResultCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
