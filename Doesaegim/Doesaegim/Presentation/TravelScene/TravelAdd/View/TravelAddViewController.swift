//
//  TravelAddViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/14.
//

import UIKit

import SnapKit

final class TravelAddViewController: UIViewController {
    
    // MARK: - UI properties
    
    private lazy var rootView = TravelAddView(frame: .zero, mode: mode)
    
    // MARK: - Properties
    
    private let viewModel: TravelAddViewModel
    private let dateFormatter: DateFormatter = Date.yearMonthDayDateFormatter
    private let mode: Mode
    private let travel: Travel?
    
    // MARK: - Lifecycles
    
    init(mode: Mode, travel: Travel? = nil) {
        viewModel = TravelAddViewModel()
        self.mode = mode
        self.travel = travel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setKeyboardNotification()
        setDelegate()
        setAddTargets()
        bindCalendar()
        if mode == .update {
            initUpdateMode()
        }
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = mode == .post ? "여행 추가" : "여행 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )
        
    }
    
    // MARK: - bind
    
    private func bindCalendar() {
        rootView.customCalendar.completionHandler = { [weak self] dates in
            self?.viewModel.travelDateTapped(dates: dates) { isSuccess in
                guard isSuccess, let startDate = dates.first, let endDate = dates.last else {
                    self?.presentErrorAlert(title: "날짜를 다시 입력해주세요")
                    return
                }
                let startDateString = Date.yearMonthDayDateFormatter.string(from: startDate)
                let endDateString = Date.yearMonthDayDateFormatter.string(from: endDate)
                self?.rootView.travelDateStartLabel.text = startDateString
                self?.rootView.travelDateStartLabel.textColor = .black
                self?.rootView.travelDateEndLabel.text = endDateString
                self?.rootView.travelDateEndLabel.textColor = .black
            }
        }
    }
    
    // MARK: - AddTarget
    
    private func setAddTargets() {
        rootView.travelTitleTextField.addTarget(
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
    
    // MARK: - SetDelegate
    
    private func setDelegate() {
        viewModel.delegate = self
        rootView.travelTitleTextField.delegate = self
    }
    
    // MARK: - UpdateMode
    
    private func initUpdateMode() {
        guard let travel, let startDate = travel.startDate, let endDate = travel.endDate else { return }
        rootView.travelTitleTextField.text = travel.name
        rootView.travelDateStartLabel.text = Date.yearMonthDayDateFormatter.string(from: startDate)
        rootView.travelDateEndLabel.text = Date.yearMonthDayDateFormatter.string(from: endDate)
        rootView.travelDateStartLabel.textColor = .black
        rootView.travelDateEndLabel.textColor = .black
        rootView.customCalendar.initUpdateMode(start: startDate, end: endDate)
    }
    
}

// MARK: - Keyboard

extension TravelAddViewController {
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
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        rootView.scrollView.contentInset = .zero
        view.gestureRecognizers?.removeAll()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Actions

extension TravelAddViewController {
    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.travelTitleDidChanged(title: sender.text)
    }
    
    @objc func addButtonTouchUpInside() {
        let result = viewModel.addTravel(
            name: rootView.travelTitleTextField.text,
            startDateString: rootView.travelDateStartLabel.text,
            endDateString: rootView.travelDateEndLabel.text
        )
        switch result {
        case .success:
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            presentErrorAlert(title: CoreDataError.saveFailure(.travel).errorDescription)
            print(error.localizedDescription)
        }
    }
    
    @objc func backButtonTouchUpInside() {
        viewModel.isClearInput(
            title: rootView.travelTitleTextField.text,
            startDate: rootView.travelDateStartLabel.text,
            endDate: rootView.travelDateEndLabel.text
        )
    }
}

// MARK: - TextField Delegate

extension TravelAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: TravelAddViewDelegate

extension TravelAddViewController: TravelAddViewDelegate {
    func travelAddFormDidChange(isValid: Bool) {
        rootView.addButton.isEnabled = isValid
        rootView.addButton.backgroundColor = isValid ? .primaryOrange : .grey3
    }
    
    func backButtonDidTap(isClear: Bool) {
        if !isClear {
            presentIsClearAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: Enums

extension TravelAddViewController {
    enum Mode {
        case post
        case update
    }
}
