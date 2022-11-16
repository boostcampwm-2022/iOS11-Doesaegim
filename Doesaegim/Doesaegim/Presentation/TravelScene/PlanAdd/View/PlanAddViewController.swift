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
        
        textField.placeholder = "일정의 이름을 입력해주세요."
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
        button.setTitle("장소를 검색해주세요", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
        navigationItem.title = "일정 추가"
    }
    
    private func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(planTitleStackView, placeTitleStackView)
        planTitleStackView.addArrangedSubviews(planTitleLabel, planTitleTextField)
        placeTitleStackView.addArrangedSubviews(placeTitleLabel, placeSearchButton)
    }
    
    private func configureConstraint() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            // TODO: 레이아웃 다 그리고 변경
            $0.height.equalTo(1500)
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
        
    }
    
}
// MARK: - Keyboard

extension PlanAddViewController {
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
// MARK: - TextField Delegate

extension PlanAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

