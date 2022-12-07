//
//  ExpenseAddLocalRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

struct ExpenseAddLocalRepository: ExpenseAddRepository {
    func addExpense(_ expenseDTO: ExpenseDTO) -> Result<Expense, Error> {
        Expense.addAndSave(with: expenseDTO)
    }
}
