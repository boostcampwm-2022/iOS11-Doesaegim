//
//  ExpenseAddPickerViewModelProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/08.
//

import Foundation

protocol ExpenseAddPickerViewModelProtocol: AnyObject {
    var delegate: ExpenseAddPickerViewModelDelegate? { get set }
    var exchangeInfos: [ExchangeData] { get set }
    var categories: [ExpenseType] { get set }
    var numberOfComponents: Int { get set }
    func fetchExchangeData(day: String) async throws
    func setExchangeValue() async throws
    func numberOfRowsInComponents() -> Int
    func pickerView(titleForRow row: Int) -> String
    func pickerView(didSelectRow row: Int)
    func addButtonTapped()
}

protocol ExpenseAddPickerViewModelDelegate: AnyObject {
    func didChangeExchangeInfo()
    func exchangeInfoConveyToViewController(item: ExchangeData)
    func expenseTypeConveyToViewController(item: ExpenseType)
}
