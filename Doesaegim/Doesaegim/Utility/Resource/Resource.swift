//
//  Resource.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

struct Resource<T: Decodable> {
    let base: String
    let paramaters: [String: String]
    let header: [String: String]
    
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: base) else { return nil }
        let queryItems = paramaters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        
        header.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
