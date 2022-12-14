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
    private let travel: Travel
    private let repository: ExpenseAddLocalRepository
    
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
    
    var expense: Expense?
    
    init(travel: Travel, expenseID: UUID? = nil) {
        self.travel = travel
        isValidName = false
        isValidAmount = false
        isValidUnit = false
        isValidCategory = false
        isValidDate = false
        isValidInput = isValidName && isValidAmount && isValidUnit && isValidCategory && isValidDate
        exchangeCalculataion = 0
        isClearInput = true
        
        repository = ExpenseAddLocalRepository()
        
        let result = repository.getExpenseDetail(with: expenseID)
        switch result {
        case .success(let expense):
            self.expense = expense
        case .failure:
            self.expense = nil
        }
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
    
    func exchangeLabelShow(amount: String?, exchangeInfo: ExchangeData?) {
        guard let amount,
              let exchangeInfo,
              let rationalAmount = Double(amount),
              let rationalUnit = Double(exchangeInfo.tradingStandardRate.convertRemoveComma()) else {
            exchangeCalculataion = -1
            return
        }
        exchangeCalculataion = Int(rationalUnit * rationalAmount * 1 / exchangeInfo.percent)
    }
    
    func addExpense(
        name: String?,
        category: String?,
        content: String?,
        cost: String?,
        date: String?,
        exchangeInfo: ExchangeData?
    ) -> Result<Expense, Error> {
        guard let name,
              let category,
              let exchangeInfo,
              let costString = cost,
              let cost = Int(costString),
              let tradingStandardRate = Double(exchangeInfo.tradingStandardRate.convertRemoveComma()),
              let dateString = date,
              let date = Date.yearMonthDayDateFormatter.date(from: dateString),
              let exchangeRateType = ExchangeRateType(currencyCode: exchangeInfo.currencyCode)
               else {
            return .failure(CoreDataError.saveFailure(.expense))
        }
        let newContent = content == StringLiteral.descriptionTextViewPlaceholder ? "" : (content ?? "")
        let expenseDTO = ExpenseDTO(
            name: name,
            category: category,
            content: newContent,
            cost: Int64(cost),
            currency: "\(exchangeRateType.icon) \(exchangeRateType.currencyName)",
            date: date,
            tradingStandardRate: tradingStandardRate * (1 / exchangeInfo.percent),
            travel: travel)
        return repository.addExpense(expenseDTO)
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
    
    func dateInputButtonTapped() {
        delegate?.presentCalendarViewController(travel: travel)
    }
    
    func pickerViewInputButtonTapped(type: ExpenseAddPickerViewController.PickerType) {
        delegate?.presentExpenseAddPickerView(type: type)
    }
    
    func fetchExpense() {
        guard let expense else { return }
        delegate?.configureExpenseDetail(expense: expense)
    }
    
    func updateExpense(
        name: String?,
        category: String?,
        content: String?,
        cost: String?,
        date: String?,
        exchangeInfo: ExchangeData?
    ) -> Result<Bool, Error> {
        guard let name,
              let category,
              let costString = cost,
              let cost = Int64(costString),
              
              let dateString = date,
              let date = Date.yearMonthDayDateFormatter.date(from: dateString),
              let expense
               else {
            return .failure(CoreDataError.saveFailure(.expense))
        }
        expense.name = name
        expense.content = content
        expense.date = date
        expense.cost = Int64(cost)
        expense.category = category
        
        if let exchangeInfo,
           let tradingStandardRate = Double(exchangeInfo.tradingStandardRate.convertRemoveComma()),
           let exchangeRateType = ExchangeRateType(rawValue: exchangeInfo.currencyCode) {
            expense.currency = "\(exchangeRateType.icon) \(exchangeRateType.currencyName)"
            expense.tradingStandardRate = tradingStandardRate
        }
        return PersistentManager.shared.saveContext()
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
