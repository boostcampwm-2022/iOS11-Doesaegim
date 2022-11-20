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
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var travelDateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var travelDateLabelStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
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
        
        textField.placeholder = "여행 제목을 입력해주세요."
        textField.layer.cornerRadius = 10
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
        label.layer.cornerRadius = 8
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .grey1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var travelDateEndLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
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
        button.layer.cornerRadius = 10
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
            guard let self, dates.count > 1 else {
                self?.viewModel.isVaildDate = false
                return
            }
            self.travelDateStartLabel.text = dates[0]
            self.travelDateEndLabel.text = dates[1]
            self.viewModel.isVaildDate = true
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
        navigationItem.title = "여행 추가"
    }
    
    private func configureSubviews() {
        [scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        
        [travelTitleStackView, travelDateStackView, addButton, customCalendar].forEach {
            contentView.addSubview($0)
        }
        
        [travelTitleLabel, travelTitleTextField].forEach {
            travelTitleStackView.addArrangedSubview($0)
        }
        
        [travelDateLabel, travelDateLabelStackView].forEach {
            travelDateStackView.addArrangedSubview($0)
        }
        
        [travelDateStartLabel, waveLabel, travelDateEndLabel].forEach {
            travelDateLabelStackView.addArrangedSubview($0)
        }
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
}

// MARK: - Keyboard

extension TravelAddViewController {
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

// MARK: - Actions

extension TravelAddViewController {
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            viewModel.isVaildTextField = false
            return
        }
        viewModel.isVaildTextField = true
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
    func isVaildView(isVaild: Bool) {
        addButton.isEnabled = isVaild
        addButton.backgroundColor = isVaild ? .primaryOrange : .grey3
    }
}
