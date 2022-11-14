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
    static func addAndSave(with object: ExpenseDTO) throws -> Expense {
        let context = PersistentManager.shared.context
        let expense = Expense(context: context)
        expense.id = object.id
        expense.name = object.name
        expense.content = object.content
        expense.date = object.date
        expense.category = object.category
        expense.currency = object.currency
        expense.cost = object.cost
        
        try PersistentManager.shared.saveContext()
        
        return expense
    }
}
