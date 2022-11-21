//
//  PersistentRepository.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/19.
//

import Foundation
import CoreData

final class PersistentRepository: PersistentRepositoryProtocol {
    
    static let shared: PersistentRepository = PersistentRepository()
    private init() {  }
    
    let manager = PersistentManager.shared
    
    func fetchTravel() -> [Travel] {
        let request = Travel.fetchRequest()
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return travels
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchExpense() -> [Expense] {
        let request = Expense.fetchRequest()
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let expenses):
            return expenses
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchTravel(offset: Int, limit: Int) -> [Travel] {
        let request = Travel.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return travels
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchExpense(offset: Int, limit: Int) -> [Expense] {
        let request = Expense.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let expenses):
            return expenses
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchTravel(with id: UUID) -> [Travel] {
        let request = Travel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return travels
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        return []
    }
    
}
