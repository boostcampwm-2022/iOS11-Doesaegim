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
    private var exchangeInfo: ExchangeData?
    
    // MARK: - Lifecycles
    
    init(travel: Travel) {
        viewModel = ExpenseAddViewModel(travel: travel)
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
    }
    
    // MARK: - Configure Function
    
    private func configureNavigation() {
        navigationItem.title = "지출 추가"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )
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
            guard let exchangeInfo else { return }
            viewModel.exchangeLabelShow(amount: sender.text, unit: exchangeInfo.tradingStandardRate)
            return
        }
    }
    
    @objc func addButtonTouchUpInside() {
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
    func selectedExchangeInfo(item: ExchangeData) {
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
    }
    
    func backButtonDidTap(isClear: Bool) {
        if !isClear {
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
