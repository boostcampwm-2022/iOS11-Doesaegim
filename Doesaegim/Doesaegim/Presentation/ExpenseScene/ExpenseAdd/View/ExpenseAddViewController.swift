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
    
    // MARK: - Lifecycles
    
    override func loadView() {
        view = rootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setKeyboardNotification()
        setAddTarget()
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
    }
}

// MARK: - Actions

extension ExpenseAddViewController {
    @objc func pickerViewButtonTouchUpInside(_ sender: UIButton) {
        let type: PickerViewController.PickerType =
        sender == rootView.moneyUnitButton ? .moneyUnit : .category
        let pickerViewController = PickerViewController(type: type)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    @objc func dateButtonTouchUpInside() {
        let calendarViewController = CalendarViewController(touchOption: .single, type: .date)
        calendarViewController.delegate = self
        present(calendarViewController, animated: true)
    }
}

// MARK: - CalendarDelegate

extension ExpenseAddViewController: CalendarViewDelegate {
    func fetchDate(dateString: String) {
        rootView.dateButton.setTitle(dateString, for: .normal)
    }
}

// MARK: - PickerDelegate

extension ExpenseAddViewController: PickerViewDelegate {
    func selectedPickerItem(item: String, type: PickerViewController.PickerType) {
        switch type {
        case .category:
            rootView.categoryButton.setTitle(item, for: .normal)
        case .moneyUnit:
            rootView.moneyUnitButton.setTitle(item, for: .normal)
        }
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
        if let keyboardFrame: NSValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.size.height -= keyboardHeight
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.size.height += keyboardHeight
            view.gestureRecognizers?.removeAll()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
