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
    var currentTravel: Travel?
    
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
    
    var isClearInput: Bool {
        didSet {
            delegate?.backButtonDidTap(isClear: isClearInput)
        }
    }
    
    init() {
        isValidName = false
        isValidAmount = false
        isValidUnit = false
        isValidCategory = false
        isValidDate = false
        isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        
        exchangeCalculataion = 0
        
        isClearInput = true
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
    
    func isValidCategoryItem(item: ExpenseType) {
        defer {
            isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
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
        let result = Expense.addAndSave(with: expense)
        switch result {
        case .success(let expense):
            completion()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    func isClearInput(
        name: String?,
        amount: String?,
        unit: String?,
        category: String?,
        date: String?,
        description: String?
    ) {
        guard let name, name.isEmpty,
              let amount, amount.isEmpty,
              let unit, unit == StringLiteral.moneyUnitButtonPlaceholder,
              let category, category == StringLiteral.categoryButtonPlaceholder,
              let date, date == StringLiteral.dateButtonPlaceholder,
              let description, description == StringLiteral.descriptionTextViewPlaceholder else {
            isClearInput = false
            return
        }
        isClearInput = true
    }
    
    
}
fileprivate extension ExpenseAddViewModel {
    enum StringLiteral {
        static let titleTextFieldPlaceholder = "지출의 이름을 입력해주세요."
        static let moneyUnitButtonPlaceholder = "화폐 단위를 입력해주세요."
        static let categoryButtonPlaceholder = "카테고리를 입력해주세요."
        static let dateButtonPlaceholder = "날짜를 입력해주세요."
        static let descriptionTextViewPlaceholder = "설명을 입력해주세요."
    }
}
