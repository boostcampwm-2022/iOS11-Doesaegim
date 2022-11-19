//
//  PersistentRepository.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/19.
//

import Foundation
import CoreData

final class PersistentRepository: PersistnetRepositoryProtocol {
    
    
    
    let manager = PersistentManager.shared
    
    func fetchTravel() -> [Travel] {
        let request = Travel.fetchRequest()
        return manager.fetch(request: request)
    }
    
    func fetchExpense() -> [Expense] {
        let request = Expense.fetchRequest()
        return manager.fetch(request: request)
    }
    
    func fetchTravel(offset: Int, limit: Int) -> [Travel] {
        let request = Travel.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        return manager.fetch(request: request)
    }
    
    func fetchExpense(offset: Int, limit: Int) -> [Expense] {
        let request = Expense.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        return manager.fetch(request: request)
    }
    
//    func delete(type: EntityType) {
//        <#code#>
//    }
    
}
