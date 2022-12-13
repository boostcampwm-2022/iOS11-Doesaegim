//
//  ExpenseAddViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/21.
//

import UIKit

import SnapKit

final class ExpenseAddViewController: UIViewController {
    
    // MARK: - UI properties
    
    private var rootView: ExpenseAddView
    
    // MARK: - Properties
    
    private let viewModel: ExpenseAddViewModel
    private var exchangeInfo: ExchangeData?
    private var mode: Mode
    
    // MARK: - Lifecycles
    
    init(travel: Travel, mode: Mode, expenseID: UUID? = nil) {
        rootView = ExpenseAddView(frame: .zero, mode: mode)
        viewModel = ExpenseAddViewModel(travel: travel, expenseID: expenseID)
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setKeyboardNotification()
        setAddTarget()
        setDelegates()
        if mode != .post {
            viewModel.fetchExpense()
        }
    }
    
    // MARK: - Configure Function
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )
        navigationItem.rightBarButtonItem = nil
        switch mode {
        case .detail:
            navigationItem.title = "지출 상세"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "pencil"),
                style: .done,
                target: self,
                action: #selector(updateButtonTapped)
            )
        case .post:
            navigationItem.title = "지출 추가"
        case .update:
            navigationItem.title = "지출 수정"
        }
    }
    
    // MARK: - AddTarget
    
    private func setAddTarget() {
        rootView.moneyUnitButton.addTarget(
            self,
            action: #selector(pickerViewButtonTouchUpInside),
            for: .touchUpInside
        )
        rootView.categoryButton.addTarget(
            self,
            action: #selector(pickerViewButtonTouchUpInside),
            for: .touchUpInside
        )
        rootView.dateButton.addTarget(
            self,
            action: #selector(dateButtonTouchUpInside),
            for: .touchUpInside
        )
        rootView.titleTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.amountTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.addButton.addTarget(
            self,
            action: #selector(addButtonTouchUpInside),
            for: .touchUpInside
        )
    }
    
    private func setDelegates() {
        viewModel.delegate = self
        rootView.descriptionTextView.delegate = self
        rootView.amountTextField.delegate = self
    }
    
    @objc func backButtonTouchUpInside() {
        viewModel.isClearInput(
            name: rootView.titleTextField.text,
            amount: rootView.amountTextField.text,
            unit: rootView.moneyUnitButton.titleLabel?.text,
            category: rootView.categoryButton.titleLabel?.text,
            date: rootView.dateButton.titleLabel?.text,
            description: rootView.descriptionTextView.text
        )
    }
    
    @objc private func updateButtonTapped() {
        let updateAction = UIAlertAction(
            title: "수정하기",
            style: .default
        ) { [weak self] _ in
            self?.mode = .update
            self?.rootView = ExpenseAddView(frame: .zero, mode: .update)
            self?.loadView()
            self?.viewDidLoad()
            self?.viewModel.isValidName = true
            self?.viewModel.isValidAmount = true
            self?.viewModel.isValidUnit = true
            self?.viewModel.isValidCategory = true
            self?.viewModel.isValidDate = true
            self?.viewModel.isValidInput = true
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        presentAlert(title: "지출 수정", message: "지출을 수정하시겠습니까?", actions: updateAction, cancelAction)
    }
}

// MARK: - Actions

extension ExpenseAddViewController {
    @objc func pickerViewButtonTouchUpInside(_ sender: UIButton) {
        let type: ExpenseAddPickerViewController.PickerType =
        sender == rootView.moneyUnitButton ? .moneyUnit : .category
        viewModel.pickerViewInputButtonTapped(type: type)
    }
    
    @objc func dateButtonTouchUpInside() {
        viewModel.dateInputButtonTapped()
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender == rootView.titleTextField {
            viewModel.isValidNameTextField(text: sender.text)
            return
        }
        
        if sender == rootView.amountTextField {
            viewModel.isValidAmountTextField(text: sender.text)
            viewModel.exchangeLabelShow(amount: sender.text, exchangeInfo: exchangeInfo)
            return
        }
    }
    
    @objc func addButtonTouchUpInside() {
        switch mode {
        case .post:
            let result = viewModel.addExpense(
                name: rootView.titleTextField.text,
                category: rootView.categoryButton.titleLabel?.text,
                content: rootView.descriptionTextView.text,
                cost: rootView.amountTextField.text,
                date: rootView.dateButton.titleLabel?.text,
                exchangeInfo: exchangeInfo
            )
            switch result {
            case .success:
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
                presentErrorAlert(title: CoreDataError.saveFailure(.expense).errorDescription)
            }
            
        case .update:
            let result = viewModel.updateExpense(
                name: rootView.titleTextField.text,
                category: rootView.categoryButton.titleLabel?.text,
                content: rootView.descriptionTextView.text,
                cost: rootView.amountTextField.text,
                date: rootView.dateButton.titleLabel?.text,
                exchangeInfo: exchangeInfo
            )
            switch result {
            case .success:
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
                presentErrorAlert(title: CoreDataError.saveFailure(.expense).errorDescription)
            }
            
        case .detail:
            break
        }
        
    }
}

// MARK: - CalendarDelegate

extension ExpenseAddViewController: CalendarViewDelegate {
    func fetchDate(date: Date) {
        let dateString = Date.yearMonthDayDateFormatter.string(from: date)
        rootView.dateButton.setTitle(dateString, for: .normal)
        viewModel.isValidDate(dateString: dateString)
    }
}

// MARK: - PickerDelegate

extension ExpenseAddViewController: ExpenseAddPickerViewDelegate {
    func selectedExchangeInfo(item: ExchangeData) {
        guard let exchangeRateType = ExchangeRateType(currencyCode: item.currencyCode) else { return }
        exchangeInfo = item
        let title = "\(exchangeRateType.icon) \(item.currencyName)"
        rootView.moneyUnitButton.setTitle(title, for: .normal)
        viewModel.isValidUnitItem(item: title)
        viewModel.exchangeLabelShow(amount: rootView.amountTextField.text, exchangeInfo: item)
    }
    
    func selectedCategory(item: ExpenseType) {
        rootView.categoryButton.setTitle(item.rawValue, for: .normal)
        viewModel.isValidCategoryItem(item: item)
    }
}

// MARK: - ViewModelDelegate

extension ExpenseAddViewController: ExpenseAddViewDelegate {
    func isValidInput(isValid: Bool) {
        rootView.addButton.isEnabled = isValid
        rootView.addButton.backgroundColor = isValid ? .primaryOrange : .grey3
    }
    
    func exchangeLabelUpdate(result: Int) {
        rootView.moneyUnitExchangeLabel.isHidden = result == -1
        rootView.moneyUnitExchangeLabel.text = "원화로 계산하면 약 \(result.numberFormatter()) 원 입니다."
    }
    
    func backButtonDidTap(isClear: Bool) {
        if !isClear && mode != .detail {
            presentIsClearAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func presentCalendarViewController(travel: Travel) {
        let calendarViewController = CalendarViewController(
            touchOption: .single, type: .date,
            startDate: travel.startDate, endDate: travel.endDate
        )
        calendarViewController.delegate = self
        present(calendarViewController, animated: true)
    }
    
    func presentExpenseAddPickerView(type: ExpenseAddPickerViewController.PickerType) {
        let pickerViewController = ExpenseAddPickerViewController(type: type)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    func configureExpenseDetail(expense: Expense) {
        guard let date = expense.date
        else { return }
        rootView.titleTextField.text = expense.name
        // TODO: 수정해야함
        rootView.amountTextField.text = "\(expense.cost)"
        
        rootView.moneyUnitButton.setTitle(
            expense.currency,
            for: .normal
        )
        rootView.categoryButton.setTitle(
            expense.category,
            for: .normal
        )
        rootView.dateButton.setTitle(
            Date.yearMonthDayDateFormatter.string(from: date),
            for: .normal
        )
        rootView.descriptionTextView.text = expense.content
    }
    
}

// MARK: - Keyboard

extension ExpenseAddViewController {
    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        let contentInsets = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height - (tabBarController?.tabBar.frame.height ?? .zero),
            right: .zero
        )
        rootView.scrollView.contentInset = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        rootView.scrollView.contentInset = .zero
    }
}

// MARK: - TextViewDelegate
extension ExpenseAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == ExpenseAddView.StringLiteral.descriptionTextViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = ExpenseAddView.StringLiteral.descriptionTextViewPlaceholder
            textView.textColor = .grey3
        }
    }
}

extension ExpenseAddViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        guard let text = textField.text else { return true }
        return text.count < Metric.amountTextFieldMaxCount
    }
}

// MARK: - Enum Mode

extension ExpenseAddViewController {
    enum Mode {
        case post
        case detail
        case update
    }
}

fileprivate extension ExpenseAddViewController {
    enum Metric {
        static let amountTextFieldMaxCount: Int = 9
    }
}
