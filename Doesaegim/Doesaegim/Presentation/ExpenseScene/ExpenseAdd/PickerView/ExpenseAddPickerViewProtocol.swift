//
//  PickerViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

protocol ExpenseAddPickerViewProtocol: AnyObject {
    var delegate: ExpenseAddPickerViewDelegate? { get set }
}

protocol ExpenseAddPickerViewDelegate: AnyObject {
    func selectedExchangeInfo(item: ExchangeResponse)
    func selectedCategory(item: ExpenseType)
}
