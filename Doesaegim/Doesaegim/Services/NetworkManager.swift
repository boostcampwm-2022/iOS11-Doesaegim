//
//  NetworkManager.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

final class NetworkManager {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func loadArray<T>(_ resource: Resource<T>, completion: @escaping ([T]) -> Void) {
        guard let request = resource.urlRequest else {
            return
        }
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let reponse = response as? HTTPURLResponse,
                  (200..<300).contains(reponse.statusCode) else {
                return
            }
            guard let data else { return }
            
            guard let result = try? JSONDecoder().decode([T].self, from: data) else { return }
            completion(result)
        }
        dataTask.resume()
    }
}
