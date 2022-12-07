//
//  PlanAddViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

// swiftlint:disable file_length

import UIKit

import SnapKit

final class PlanAddViewController: UIViewController {
    
    // MARK: - UI properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var planTitleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var planTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "일정 이름"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var planTitleTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = StringLiteral.planTextFieldPlaceHolder
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .grey1
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addPadding(witdh: 8)
        textField.delegate = self
        return textField
    }()
    
    private lazy var placeTitleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var placeTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "장소"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var placeSearchButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .grey1
        button.setTitleColor(.grey3, for: .normal)
        button.setTitle(StringLiteral.placeTextPlaceHolder, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "날짜와 시간"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateInputButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .grey1
        button.setTitleColor(.grey3, for: .normal)
        button.setTitle(StringLiteral.datePlaceHolder, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "설명"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        
        textView.layer.cornerRadius = 10
        textView.text = StringLiteral.descriptionTextViewPlaceHolder
        textView.textColor = .grey3
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .grey1
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.delegate = self
        return textView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()

        button.setTitle("여행 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grey3
        button.isEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: PlanAddViewModel
    private let travel: Travel
    
    // MARK: - Lifecycles
    
    init(travel: Travel) {
        viewModel = PlanAddViewModel()
        self.travel = travel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        dateInputButton.addTarget(
            self,
            action: #selector(dateInputButtonTouchUpInside),
            for: .touchUpInside
        )
        planTitleTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        placeSearchButton.addTarget(
            self,
            action: #selector(placeButtonTouchUpInside),
            for: .touchUpInside
        )
        addButton.addTarget(
            self,
            action: #selector(addButtonTouchUpInside),
            for: .touchUpInside)
        viewModel.delegate = self
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
        configureNavigationBar()
        setKeyboardNotification()
    }
    
    private func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            planTitleStackView, placeTitleStackView, dateStackView,
            descriptionTitleLabel, descriptionTextView, addButton
        )
        planTitleStackView.addArrangedSubviews(planTitleLabel, planTitleTextField)
        placeTitleStackView.addArrangedSubviews(placeTitleLabel, placeSearchButton)
        dateStackView.addArrangedSubviews(dateTitleLabel, dateInputButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func configureConstraint() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        planTitleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        planTitleTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        placeTitleStackView.snp.makeConstraints {
            $0.top.equalTo(planTitleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        placeSearchButton.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(placeTitleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateInputButton.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(40)
            $0.height.equalTo(48)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "일정 추가"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
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
        scrollView.contentInset = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Action

extension PlanAddViewController {
    @objc func dateInputButtonTouchUpInside() {
        let calendarViewController = CalendarViewController(
            touchOption: .single, type: .dateAndTime, startDate: travel.startDate, endDate: travel.endDate
        )
        print(travel)
        calendarViewController.delegate = self
        
        present(calendarViewController, animated: true)
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
        guard let name = planTitleTextField.text,
              let dateString = dateInputButton.titleLabel?.text,
              let date = Date.convertDateStringToDate(
                dateString: dateString,
                formatter: Date.yearMonthDayTimeDateFormatter
              ),
              let content = descriptionTextView.text
        else {
            return
        }
        let planDTO = PlanDTO(name: name, date: date, content: content, travel: travel)
        viewModel.postPlan(plan: planDTO) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func backButtonTouchUpInside() {
        viewModel.isClearInput(
            title: planTitleTextField.text,
            place: placeSearchButton.titleLabel?.text,
            date: dateInputButton.titleLabel?.text,
            description: descriptionTextView.text
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
        if textView.text == StringLiteral.descriptionTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = StringLiteral.descriptionTextViewPlaceHolder
            textView.textColor = .grey3
        }
    }
}

// MARK: - PlanAddViewDelegate

extension PlanAddViewController: PlanAddViewDelegate {
    func isVaildInputs(isValid: Bool) {
        addButton.isEnabled = isValid
        addButton.backgroundColor = isValid ? .primaryOrange : .grey3
    }
    
    func planAddViewDidSelectLocation(locationName: String) {
        placeSearchButton.setTitle(locationName, for: .normal)
    }
    
    func backButtonDidTap(isClear: Bool) {
        if !isClear {
            presentIsClearAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - SearchingLocationViewControllerDelegate

extension PlanAddViewController: SearchingLocationViewControllerDelegate {
    func searchingLocationViewController(didSelect location: LocationDTO) {
        viewModel.isValidPlace(place: location)
    }
}

// MARK: - Calendar Delegate

extension PlanAddViewController: CalendarViewDelegate {
    func fetchDate(dateString: String) {
        dateInputButton.setTitle(dateString, for: .normal)
        viewModel.isValidDate(dateString: dateString)
    }
}

// MARK: - Namespaces

extension PlanAddViewController {
    enum StringLiteral {
        static let planTextFieldPlaceHolder = "일정의 이름을 입력해주세요."
        static let placeTextPlaceHolder = "장소를 검색해 주세요."
        static let datePlaceHolder = "날짜와 시간을 입력해 주세요."
        static let descriptionTextViewPlaceHolder = "설명을 입력해주세요."
    }
}
