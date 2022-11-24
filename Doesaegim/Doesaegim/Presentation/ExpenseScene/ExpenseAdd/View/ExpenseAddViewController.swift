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
    
    private let rootView = ExpenseAddView()
    
    // MARK: - Properties
    
    private let viewModel: ExpenseAddViewModel
    private var exchangeInfo: ExchangeResponse?
    private let travel: Travel?
    
    // MARK: - Lifecycles
    
    init(travel: Travel?) {
        viewModel = ExpenseAddViewModel()
        self.travel = travel
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
        viewModel.delegate = self
    }
    
    // MARK: - Configure Function
    
    private func configureNavigation() {
        navigationItem.title = "지출 추가"
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
}

// MARK: - Actions

extension ExpenseAddViewController {
    @objc func pickerViewButtonTouchUpInside(_ sender: UIButton) {
        let type: ExpenseAddPickerViewController.PickerType =
        sender == rootView.moneyUnitButton ? .moneyUnit : .category
        let pickerViewController = ExpenseAddPickerViewController(type: type)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    @objc func dateButtonTouchUpInside() {
        let calendarViewController = CalendarViewController(touchOption: .single, type: .date)
        calendarViewController.delegate = self
        present(calendarViewController, animated: true)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender == rootView.titleTextField {
            viewModel.isValidNameTextField(text: sender.text)
            return
        }
        
        if sender == rootView.amountTextField {
            viewModel.isValidAmountTextField(text: sender.text)
            guard let exchangeInfo else { return }
            viewModel.exchangeLabelShow(amount: sender.text, unit: exchangeInfo.tradingStandardRate)
            return
        }
    }
    
    @objc func addButtonTouchUpInside() {
        guard let name = rootView.titleTextField.text,
              let category = rootView.categoryButton.titleLabel?.text,
              let content = rootView.descriptionTextView.text,
              let exchangeInfo,
              let tradingStandardRate = Double(exchangeInfo.tradingStandardRate.convertRemoveComma()),
              let amountText = rootView.amountTextField.text,
              let amount = Int(amountText),
              let dateString = rootView.dateButton.titleLabel?.text,
              let date = Date.yearMonthDayDateFormatter.date(from: dateString),
              let travel = travel else {
            return
        }
            
        let expenseDTO = ExpenseDTO(
            name: name,
            category: category,
            content: content,
            cost: Int64(tradingStandardRate * Double(amount)),
            currency: exchangeInfo.currencyName,
            date: date,
            travel: travel)
        
        viewModel.postExpense(expense: expenseDTO) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            print("지출 저장 성공!")
        }
    }
    
}

// MARK: - CalendarDelegate

extension ExpenseAddViewController: CalendarViewDelegate {
    func fetchDate(dateString: String) {
        rootView.dateButton.setTitle(dateString, for: .normal)
        viewModel.isValidDate(dateString: dateString)
    }
}

// MARK: - PickerDelegate

extension ExpenseAddViewController: ExpenseAddPickerViewDelegate {
    func selectedExchangeInfo(item: ExchangeResponse) {
        guard let exchangeRateType = ExchangeRateType(currencyCode: item.currencyCode) else { return }
        exchangeInfo = item
        let title = "\(exchangeRateType.icon) \(item.currencyName)"
        rootView.moneyUnitButton.setTitle(title, for: .normal)
        viewModel.isValidUnitItem(item: title)
        viewModel.exchangeLabelShow(amount: rootView.amountTextField.text, unit: item.tradingStandardRate)
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
        print(result)
    }
}

// MARK: - Keyboard

extension ExpenseAddViewController {
    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
  
    @objc private func keyboardDidShow(notification: NSNotification) {
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
