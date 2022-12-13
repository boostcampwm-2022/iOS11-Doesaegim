//
//  ExpenseAddLocalRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

struct ExpenseAddLocalRepository: ExpenseAddRepository {
    
    private let persistentManager = PersistentManager.shared
    
    func addExpense(_ expenseDTO: ExpenseDTO) -> Result<Expense, Error> {
        Expense.addAndSave(with: expenseDTO)
    }
    
    func getExpenseDetail(with id: UUID?) -> Result<Expense, CoreDataError> {
        guard let id else {
            return .failure(.fetchFailure(.expense))
        }
        
        let result = persistentManager.fetch(request: Expense.fetchRequest())
        
        switch result {
        case .success(let expenses):
            guard let expense = expenses.first(where: { $0.id == id }) else {
                return .failure(.fetchFailure(.expense))
            }
            return .success(expense)
        case .failure:
            return .failure(.fetchFailure(.expense))
        }
    }
}
