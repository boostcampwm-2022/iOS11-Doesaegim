//
//  SearchingLocationRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/12/08.
//

import Foundation

protocol SearchingLocationRepository {
    func search(
        with keyword: String,
        completion: @escaping ((Result<[SearchResultCellViewModel], NetworkError>) -> Void)
    )
}
