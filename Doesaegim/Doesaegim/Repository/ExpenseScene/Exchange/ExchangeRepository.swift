//
//  ExchangeRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/08.
//

import Foundation

protocol ExchangeRepository {
    func fetchExchangeData(
        day: String
    ) async throws -> Result<[ExchangeResponse], NetworkError>
}
