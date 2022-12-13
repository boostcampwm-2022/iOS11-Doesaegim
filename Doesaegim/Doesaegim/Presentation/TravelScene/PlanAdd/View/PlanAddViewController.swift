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
    
    private var rootView: PlanAddView
    
    // MARK: - Properties

    weak var delegate: PlanAddViewControllerDelegate?

    private let viewModel: PlanAddViewModel
    
    private var mode: Mode
    
    private let planID: UUID?
    
    // MARK: - Lifecycles
    
    init(travel: Travel, mode: Mode, planID: UUID? = nil) {
        viewModel = PlanAddViewModel(travel: travel, planID: planID)
        rootView = PlanAddView(frame: .zero, mode: mode)
        self.mode = mode
        self.planID = planID
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
        if mode != .post {
            viewModel.fetchPlan()
        }
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - Configure Functions
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )
        navigationItem.rightBarButtonItem = nil
        switch mode {
        case .detail:
            navigationItem.title = "일정 상세"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "pencil"),
                style: .done,
                target: self,
                action: #selector(updateButtonTapped)
            )
        case .post:
            navigationItem.title = "일정 추가"
        case .update:
            navigationItem.title = "일정 수정"
        }
        
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
        rootView.placeSearchClearButton.addTarget(
            self,
            action: #selector(placeClearButtonDidTap),
            for: .touchUpInside
        )
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
    
    @objc private func updateButtonTapped() {
        let updateAction = UIAlertAction(
            title: "수정하기",
            style: .default
        ) { [weak self] _ in
            self?.mode = .update
            self?.rootView = PlanAddView(frame: .zero, mode: .update)
            self?.loadView()
            self?.viewDidLoad()
            self?.viewModel.isValidInput = true
            self?.viewModel.isValidDate = true
            self?.viewModel.isValidName = true
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        presentAlert(title: "일정 수정", message: "일정을 수정하시겠습니까?", actions: updateAction, cancelAction)
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
        viewModel.placeButtonTapped()
    }
    
    @objc func addButtonTouchUpInside() {
        
        switch mode {
        case .post:
            let result = viewModel.addPlan(
                name: rootView.planTitleTextField.text,
                dateString: rootView.dateInputButton.titleLabel?.text,
                locationDTO: viewModel.selectedLocation,
                content: rootView.descriptionTextView.text
            )
            
            switch result {
            case .success(let plan):
                delegate?.planAddViewControllerDidAddPlan(plan)
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                presentErrorAlert(title: CoreDataError.saveFailure(.plan).errorDescription)
                print(error.localizedDescription)
            }
        case .update:
            let result = viewModel.updatePlan(
                name: rootView.planTitleTextField.text,
                dateString: rootView.dateInputButton.titleLabel?.text,
                content: rootView.descriptionTextView.text
            )
            switch result {
            case .success:
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                presentErrorAlert(title: CoreDataError.updateFailure(.plan).errorDescription)
                print(error.localizedDescription)
            }
            
        case .detail:
            break
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
    
    @objc func placeClearButtonDidTap() {
        viewModel.removeLocation()
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
        if !isClear && mode != .detail {
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
    
    func presentSearchingLocationViewController() {
        let searchingLocationViewController = SearchingLocationViewController()
        searchingLocationViewController.delegate = self
        navigationController?.pushViewController(searchingLocationViewController, animated: true)
    }
    
    func configurePlanDetail(plan: Plan) {
        rootView.planTitleTextField.text = plan.name
        if let location = plan.location {
            rootView.placeSearchButton.setTitle(location.name, for: .normal)
        } else {
            rootView.placeSearchButton.setTitle("입력하신 장소가 없어요.", for: .normal)
        }
        
        guard let date = plan.date else { return }
        
        rootView.dateInputButton.setTitle(Date.yearMonthDayTimeDateFormatter.string(from: date), for: .normal)
        rootView.descriptionTextView.text = plan.content
    }
}

// MARK: - SearchingLocationViewControllerDelegate

extension PlanAddViewController: SearchingLocationViewControllerDelegate {
    func searchingLocationViewController(didSelect location: LocationDTO) {
        viewModel.selectedLocation = location
    }
}

// MARK: - Calendar Delegate

extension PlanAddViewController: CalendarViewDelegate {
    func fetchDate(date: Date) {
        let dateString = Date.yearMonthDayTimeDateFormatter.string(from: date)
        rootView.dateInputButton.setTitle(dateString, for: .normal)
        viewModel.isValidDate(dateString: dateString)
    }
}

// MARK: PlanMode Enum

extension PlanAddViewController {
    
    enum Mode {
        case post
        case update
        case detail
    }
}
