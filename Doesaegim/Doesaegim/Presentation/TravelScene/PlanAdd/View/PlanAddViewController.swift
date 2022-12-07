//
//  PlanAddViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import UIKit

import SnapKit

final class PlanAddViewController: UIViewController {
    
    // MARK: - UI properties
    
    private let rootView = PlanAddView()
    
    // MARK: - Properties
    
    private let viewModel: PlanAddViewModel
    private var locationDTO: LocationDTO?
    
    // MARK: - Lifecycles
    
    init(travel: Travel) {
        viewModel = PlanAddViewModel(travel: travel)
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
        configureNavigationBar()
        setKeyboardNotification()
        setDelegate()
        setAddTargets()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - Configure Functions
    
    private func configureNavigationBar() {
        navigationItem.title = "일정 추가"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )
    }
    
    // MARK: - Set Delegate
    
    private func setDelegate() {
        viewModel.delegate = self
        rootView.planTitleTextField.delegate = self
        rootView.descriptionTextView.delegate = self
    }
    
    // MARK: - AddTarget
    
    private func setAddTargets() {
        rootView.dateInputButton.addTarget(
            self,
            action: #selector(dateInputButtonTouchUpInside),
            for: .touchUpInside
        )
        rootView.planTitleTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        rootView.placeSearchButton.addTarget(
            self,
            action: #selector(placeButtonTouchUpInside),
            for: .touchUpInside
        )
        rootView.addButton.addTarget(
            self,
            action: #selector(addButtonTouchUpInside),
            for: .touchUpInside)
    }
}
// MARK: - Keyboard

extension PlanAddViewController {
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
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        rootView.scrollView.contentInset = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Action

extension PlanAddViewController {
    @objc func dateInputButtonTouchUpInside() {
        viewModel.dateButtonTapped()
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.isValidPlanName(name: sender.text)
    }
    
    @objc func placeButtonTouchUpInside() {
        let searchingLocationViewController = SearchingLocationViewController()
        searchingLocationViewController.delegate = self
        navigationController?.pushViewController(searchingLocationViewController, animated: true)
    }
    
    @objc func addButtonTouchUpInside() {
        let result = viewModel.addPlan(
            name: rootView.planTitleTextField.text,
            dateString: rootView.dateInputButton.titleLabel?.text,
            locationDTO: locationDTO,
            content: rootView.descriptionTextView.text
        )
        
        switch result {
        case .success:
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            presentErrorAlert(title: CoreDataError.saveFailure(.plan).errorDescription)
            print(error.localizedDescription)
        }
    }
    
    @objc func backButtonTouchUpInside() {
        viewModel.isClearInput(
            title: rootView.planTitleTextField.text,
            place: rootView.placeSearchButton.titleLabel?.text,
            date: rootView.dateInputButton.titleLabel?.text,
            description: rootView.descriptionTextView.text
        )
    }
}

// MARK: - TextField Delegate

extension PlanAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TextView Delegate

extension PlanAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PlanAddView.StringLiteral.descriptionTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = PlanAddView.StringLiteral.descriptionTextViewPlaceHolder
            textView.textColor = .grey3
        }
    }
}

// MARK: - PlanAddViewDelegate

extension PlanAddViewController: PlanAddViewDelegate {
    func isVaildInputs(isValid: Bool) {
        rootView.addButton.isEnabled = isValid
        rootView.addButton.backgroundColor = isValid ? .primaryOrange : .grey3
    }
    
    func planAddViewDidSelectLocation(locationName: String) {
        rootView.placeSearchButton.setTitle(locationName, for: .normal)
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
            touchOption: .single, type: .dateAndTime, startDate: travel.startDate, endDate: travel.endDate
        )
        calendarViewController.delegate = self
        present(calendarViewController, animated: true)
    }
}

// MARK: - SearchingLocationViewControllerDelegate

extension PlanAddViewController: SearchingLocationViewControllerDelegate {
    func searchingLocationViewController(didSelect location: LocationDTO) {
        viewModel.isValidPlace(place: location)
        locationDTO = location
    }
}

// MARK: - Calendar Delegate

extension PlanAddViewController: CalendarViewDelegate {
    func fetchDate(dateString: String) {
        rootView.dateInputButton.setTitle(dateString, for: .normal)
        viewModel.isValidDate(dateString: dateString)
    }
}
