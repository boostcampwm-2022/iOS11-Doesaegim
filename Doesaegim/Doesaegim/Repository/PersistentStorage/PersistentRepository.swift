//
//  PersistentRepository.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/19.
//

import Foundation

final class PersistentRepository: PersistnetRepositoryProtocol {
    func fetch<T>(with: T) -> [T] where T : NSManagedObject {
        <#code#>
    }
    
    func fetch<T>(with: T, offset: Int, limit: Int) -> [T] where T : NSManagedObject {
        <#code#>
    }
    
    func delete<T>(with: T) where T : NSManagedObject {
        <#code#>
    }
    
    
}
