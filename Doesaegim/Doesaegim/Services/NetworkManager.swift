//
//  NetworkManager.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequest
    case responseError
    case statusCodeError(code: Int)
    case decodeError
}

final class NetworkManager {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func loadArray<T>(_ resource: Resource<T>) async throws -> Result<[T], NetworkError> {
        guard let request = resource.urlRequest else {
            return .failure(.invalidRequest)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let reponse = response as? HTTPURLResponse else {
            return .failure(.responseError)
        }
        guard (200..<300).contains(reponse.statusCode) else {
            return .failure(.statusCodeError(code: reponse.statusCode))
        }
        
        guard let result = try? JSONDecoder().decode([T].self, from: data) else {
            return .failure(.decodeError)
        }
        return .success(result)
    }
}
