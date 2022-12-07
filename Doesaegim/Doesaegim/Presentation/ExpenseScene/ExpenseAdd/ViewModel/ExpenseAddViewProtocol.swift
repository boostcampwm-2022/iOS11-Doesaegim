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
    
    var isClearInput: Bool { get set }
    
    func isValidNameTextField(text: String?)
    func isValidAmountTextField(text: String?)
    func isValidUnitItem(item: String?)
    func isValidCategoryItem(item: ExpenseType)
    func isValidDate(dateString: String?)
    func isClearInput(
        name: String?,
        amount: String?,
        unit: String?,
        category: String?,
        date: String?,
        description: String?
    )
    func exchangeLabelShow(amount: String?, unit: String)
    func addExpense(
        name: String?,
        category: String?,
        content: String?,
        cost: String?,
        date: String?,
        exchangeInfo: ExchangeData?
    ) -> Result<Expense, Error>
    
    func dateInputButtonTapped()
    
}

protocol ExpenseAddViewDelegate: AnyObject {
    func isValidInput(isValid: Bool)
    func exchangeLabelUpdate(result: Int)
    func backButtonDidTap(isClear: Bool)
    func presentCalendarViewController(travel: Travel)
}
