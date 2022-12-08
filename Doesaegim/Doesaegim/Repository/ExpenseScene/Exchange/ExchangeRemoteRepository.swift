//
//  ExchangeRemoteRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/08.
//

import Foundation

struct ExchangeRemoteRepository: ExchangeRepository {
    func fetchExchangeData(day: String) async throws -> Result<[ExchangeResponse], NetworkError> {
        let network = NetworkManager(configuration: .default)
        var paramaters: [String: String] = [:]
        paramaters["authkey"] = ExchangeAPI.authkey
        paramaters["data"] = ExchangeAPI.dataCode
        paramaters["searchdate"] = day
        
        let resource = Resource<ExchangeResponse>(
            base: ExchangeAPI.exchangeURL,
            paramaters: paramaters,
            header: [:])
        
        return try await network.loadArray(resource)
    }
}
