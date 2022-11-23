//
//  ExpenseAddViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

final class ExpenseAddViewModel: ExpenseAddViewProtocol {
    
    // MARK: - Properties
    
    weak var delegate: ExpenseAddViewDelegate?
    
    var isValidName: Bool
    var isValidAmount: Bool
    var isValidUnit: Bool
    var isValidCategory: Bool
    var isValidDate: Bool
    
    var isValidInput: Bool {
        didSet {
            delegate?.isValidInput(isValid: isValidInput)
        }
    }
    
    var exchangeCalculataion: Int {
        didSet {
            delegate?.exchangeLabelUpdate(result: exchangeCalculataion)
        }
    }
    
    init() {
        self.isValidName = false
        self.isValidAmount = false
        self.isValidUnit = false
        self.isValidCategory = false
        self.isValidDate = false
        self.isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        
        exchangeCalculataion = 0
    }
    
    // MARK: - Helpers
    
    func isValidNameTextField(text: String?) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        }
        guard let text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidName = false
            return
        }
        isValidName = true
    }
    
    func isValidAmountTextField(text: String?) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        }
        guard let text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidAmount = false
            return
        }
        isValidAmount = true
    }
    
    func isValidUnitItem(item: String?) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        }
        guard let item,
              !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidUnit = false
            return
        }
        isValidUnit = true
    }
    
    func isValidCategoryItem(item: String?) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        }
        guard let item,
              !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidCategory = false
            return
        }
        isValidCategory = true
    }
    
    func isValidDate(dateString: String?) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        }
        
        guard let dateString, let date = Date.convertDateStringToDate(
            dateString: dateString,
            formatter: Date.yearMonthDayDateFormatter
        ) else {
            isValidDate = false
            return
        }
        isValidDate = true
    }
    
    func exchangeLabelShow(amount: String?, unit: String) {
        guard let amount,
              let rationalAmount = Double(amount),
              let rationalUnit = Double(unit.convertRemoveComma()) else {
            exchangeCalculataion = -1
            return
        }
        exchangeCalculataion = Int(rationalAmount * rationalUnit)
    }
    
    
    func postExpense(expense: ExpenseDTO, completion: @escaping () -> Void) {
        // TODO: 지출 추가 메서드 작성
    }
    
    
}
