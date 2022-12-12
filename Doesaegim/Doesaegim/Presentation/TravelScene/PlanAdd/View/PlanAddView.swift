//
//  PlanAddView.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import UIKit

final class PlanAddView: UIView {
    
    // MARK: - UI properties
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    
    private let planTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let planTitleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "일정 이름"
        
        return label
    }()
    
    let planTitleTextField: AddViewTextField = {
        let textField = AddViewTextField()
        textField.placeholder = StringLiteral.planTextFieldPlaceHolder
        
        return textField
    }()
    
    private let placeTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let placeTitleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "장소"
        
        return label
    }()
    
    let placeSearchButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.placeTextPlaceHolder, for: .normal)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        return button
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let dateTitleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "날짜와 시간"
        
        return label
    }()
    
    let dateInputButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.datePlaceHolder, for: .normal)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        
        return button
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let descriptionTitleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "설명"
        
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        textView.layer.cornerRadius = Metric.textViewCornerRadius
        textView.text = StringLiteral.descriptionTextViewPlaceHolder
        textView.textColor = .grey3
        textView.font = .systemFont(ofSize: Metric.textViewFontSize, weight: .regular)
        textView.backgroundColor = .grey1
        textView.contentInset = Metric.textViewInset
        return textView
    }()
    
    let addButton: AddViewCompleteButton = {
        let button = AddViewCompleteButton()
        button.setTitle("일정 추가", for: .normal)
        
        return button
    }()
    
    // MARK: Properties
    
    private let mode: PlanAddViewController.Mode
    
    // MARK: - Lifecycles
    
    init(frame: CGRect, mode: PlanAddViewController.Mode) {
        self.mode = mode
        super.init(frame: frame)
        configureViews()
        setAddTarget()
        if mode == .detail {
            setDetailMode()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            planTitleStackView, placeTitleStackView, dateStackView, descriptionStackView
        )
        planTitleStackView.addArrangedSubviews(planTitleLabel, planTitleTextField)
        placeTitleStackView.addArrangedSubviews(placeTitleLabel, placeSearchButton)
        dateStackView.addArrangedSubviews(dateTitleLabel, dateInputButton)
        descriptionStackView.addArrangedSubviews(descriptionTitleLabel, descriptionTextView, addButton)
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
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    private func setDetailMode() {
        planTitleTextField.isEnabled = false
        placeSearchButton.isEnabled = false
        dateInputButton.isEnabled = false
        descriptionTextView.isEditable = false
        addButton.isHidden = true
    }
    
    // MARK: - Keyboard
    
    private func setAddTarget() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
}

// MARK: - Namespaces

extension PlanAddView {
    enum Metric {
        static let stackViewSpacing: CGFloat = 12
        static let textViewCornerRadius: CGFloat = 10
        static let textViewFontSize: CGFloat = 14
        static let textViewInset: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    enum StringLiteral {
        static let planTextFieldPlaceHolder = "일정의 이름을 입력해주세요."
        static let placeTextPlaceHolder = "장소를 검색해 주세요."
        static let datePlaceHolder = "날짜와 시간을 입력해 주세요."
        static let descriptionTextViewPlaceHolder = "설명을 입력해주세요."
    }
}
