//
//  Expense+CoreDataClass.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//
//

import CoreData
import Foundation


public class Expense: NSManagedObject {
    
    // MARK: - Functions
    
    @discardableResult
    static func addAndSave(with object: ExpenseDTO) -> Result<Expense, Error> {
        let context = PersistentManager.shared.context
        let expense = Expense(context: context)
        expense.id = object.id
        expense.name = object.name
        expense.content = object.content
        expense.date = object.date
        expense.category = object.category
        expense.currency = object.currency
        expense.cost = object.cost
        
        let result = PersistentManager.shared.saveContext()
        
        switch result {
        case .success(let isSuccess):
            if isSuccess {
                return .success(expense)
            }
        case .failure(let error):
            return .failure(error)
        }
        return .failure(CoreDataError.saveFailure(.expense))
    }
    
    static func convertToViewModel(from expense: Expense) -> ExpenseInfoViewModel? {
        
        guard let id = expense.id,
              let name = expense.name,
              let content = expense.content,
              let date = expense.date else { return nil }
        
        let viewModel = ExpenseInfoViewModel(
            uuid: id,
            name: name,
            content: content,
            cost: Int(expense.cost),
            date: date
        )
        
        return viewModel
    }
}
