//
//  ExpenseAddViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

protocol ExpenseAddViewProtocol: AnyObject {
    var delegate: ExpenseAddViewDelegate? { get set }
    
    var isValidName: Bool { get set }
    var isValidAmount: Bool { get set }
    var isValidUnit: Bool { get set }
    var isValidCategory: Bool { get set }
    var isValidDate: Bool { get set }
    var isValidInput: Bool { get set }
    
    func isValidNameTextField(text: String?)
    func isValidAmountTextField(text: String?)
    func isValidUnitItem(item: String?)
    func isValidCategoryItem(item: String?)
    func isValidDate(dateString: String?)
    
    func exchangeLabelShow(amount: String?, unit: String)
    
    func postExpense(expense: ExpenseDTO, completion: @escaping () -> Void)
}

protocol ExpenseAddViewDelegate: AnyObject {
    func isValidInput(isValid: Bool)
    func exchangeLabelUpdate(result: Int)
}
