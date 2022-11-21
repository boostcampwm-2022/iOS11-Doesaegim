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
    
    func fetchTravel() -> Result<[Travel], Error> {
        let request = Travel.fetchRequest()
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return .success(travels)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.fetchFailure(.travel))
        }
    }
    
    func fetchExpense() -> Result<[Expense], Error> {
        let request = Expense.fetchRequest()
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let expenses):
            return .success(expenses)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.fetchFailure(.expense))
        }
    }
    
    func fetchTravel(offset: Int, limit: Int) -> Result<[Travel], Error> {
        let request = Travel.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return .success(travels)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.fetchFailure(.travel))
        }
    }
    
    func fetchExpense(offset: Int, limit: Int) -> Result<[Expense], Error> {
        let request = Expense.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let expenses):
            return .success(expenses)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.fetchFailure(.expense))
        }
    }
    
    func fetchTravel(with id: UUID) -> Result<[Travel], Error> {
        let request = Travel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        let result = manager.fetch(request: request)
        switch result {
        case .success(let travels):
            return .success(travels)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.fetchFailure(.travel))
        }
    }
    
}
