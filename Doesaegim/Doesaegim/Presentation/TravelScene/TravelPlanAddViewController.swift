//
//  TravelPlanAddViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/14.
//

import UIKit

import SnapKit

final class TravelPlanAddViewController: UIViewController {
    
    // MARK: - UI properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var travelTitleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var travelDateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var travelDateLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var travelTitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "여행 제목"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var travelTitleTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "날짜"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var travelDateStartLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "~"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("여행 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryOrange
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setKeyboardNotification()
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
        
        [travelTitleStackView, travelDateStackView, datePicker, addButton].forEach {
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
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(travelDateStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.top.equalTo(datePicker.snp.bottom).offset(100)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - Keyboard
extension TravelPlanAddViewController {
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

extension TravelPlanAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
