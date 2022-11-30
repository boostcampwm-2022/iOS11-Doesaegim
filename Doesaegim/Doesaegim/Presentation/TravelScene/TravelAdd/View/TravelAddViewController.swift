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
    
    private lazy var travelTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        
        return stackView
    }()
    
    private lazy var travelDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Metric.spacing
        
        return stackView
    }()
    
    private lazy var travelDateLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var travelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 제목"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var travelTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.travelTitlePlaceholder
        textField.layer.cornerRadius = Metric.cornerRadius
        textField.backgroundColor = .grey1
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addPadding(witdh: 8)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var travelDateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var travelDateStartLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = Metric.cornerRadius
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .grey1
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var travelDateEndLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = Metric.cornerRadius
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .grey1
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var waveLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.backgroundColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("여행 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grey3
        button.isEnabled = false
        button.layer.cornerRadius = Metric.cornerRadius
        
        return button
    }()
    
    private lazy var customCalendar: CustomCalendar = {
        let customCalendar = CustomCalendar(
            frame: .zero,
            collectionViewLayout: CustomCalendar.createLayout(),
            touchOption: .double
        )
        
        // 2개 날짜 선택시 라벨에 나타나도록
        customCalendar.completionHandler = { [weak self] dates in
            self?.viewModel.travelDateTapped(dates: dates) { isSuccess in
                if isSuccess {
                    self?.travelDateStartLabel.text = Date.yearMonthDayDateFormatter.string(from: dates[0])
                    self?.travelDateEndLabel.text = Date.yearMonthDayDateFormatter.string(from: dates[1])
                } else {
                    self?.presentErrorAlert(title: "날짜를 다시 입력해주세요")
                }
                
            }
        }
        return customCalendar
    }()
    
    // MARK: - Properties
    
    private let viewModel: TravelAddViewModel
    private let dateFormatter: DateFormatter = Date.yearMonthDayDateFormatter
    
    // MARK: - Lifecycles
    
    init() {
        viewModel = TravelAddViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureViews()
        setKeyboardNotification()
        travelTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addButton.addTarget(self, action: #selector(addButtonTouchUpInside), for: .touchUpInside)
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
        configureNavigationBar()
    }
    
    private func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(travelTitleStackView, travelDateStackView, addButton, customCalendar)
        travelTitleStackView.addArrangedSubviews(travelTitleLabel, travelTitleTextField)
        travelDateStackView.addArrangedSubviews(travelDateLabel, travelDateLabelStackView)
        travelDateLabelStackView.addArrangedSubviews(travelDateStartLabel, waveLabel, travelDateEndLabel)
    }
    
    private func configureConstraint() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        travelTitleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        travelTitleTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        travelDateStackView.snp.makeConstraints {
            $0.top.equalTo(travelTitleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        travelDateStartLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        
        travelDateEndLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
        }

        customCalendar.snp.makeConstraints {
            $0.top.equalTo(travelDateStackView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(customCalendar.snp.width).multipliedBy(1.3)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.top.equalTo(customCalendar.snp.bottom).offset(40)
            $0.height.equalTo(48)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "여행 추가"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouchUpInside)
        )

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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
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
        guard let name = travelTitleTextField.text,
              let startDateString = travelDateStartLabel.text,
              let startDate = dateFormatter.date(from: startDateString),
              let endDateString = travelDateEndLabel.text,
              let endDate = dateFormatter.date(from: endDateString) else { return }
        
        let travelDTO = TravelDTO(name: name, startDate: startDate, endDate: endDate)
        
        viewModel.postTravel(travel: travelDTO) { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func backButtonTouchUpInside() {
        viewModel.isClearInput(
            title: travelTitleTextField.text,
            startDate: travelDateStartLabel.text,
            endDate: travelDateEndLabel.text
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
        addButton.isEnabled = isValid
        addButton.backgroundColor = isValid ? .primaryOrange : .grey3
    }
    
    func backButtonDidTap(isClear: Bool) {
        if !isClear {
            let okAction = UIAlertAction(title: "뒤로가기", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "작성", style: .cancel)
            presentAlert(
                title: "취소",
                message: "현재 작성된 정보가 사라집니다.\n계속 하시겠습니까?",
                actions: okAction, cancelAction
            )
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Constants

fileprivate extension TravelAddViewController {
    
    enum StringLiteral {
        static let travelTitlePlaceholder = "여행 제목을 입력해주세요."
    }
    
    enum Metric {
        static let spacing: CGFloat = 12
        static let cornerRadius: CGFloat = 10
    }
}
