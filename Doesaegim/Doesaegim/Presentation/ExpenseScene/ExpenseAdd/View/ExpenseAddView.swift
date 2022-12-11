//
//  ExpenseAddView.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/21.
//

import UIKit

final class ExpenseAddView: UIView {
    
    // MARK: - UI properties
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let titleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "지출 이름"
    
        return label
    }()
    
    let titleTextField: AddViewTextField = {
        let textField = AddViewTextField()
        textField.placeholder = StringLiteral.titleTextFieldPlaceholder
        
        return textField
    }()
    
    private let amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let amountLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "지출 액수"
        
        return label
    }()
    
    let amountTextField: AddViewTextField = {
        let textField = AddViewTextField()
        textField.placeholder = StringLiteral.amountTextFieldPlaceholder
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let moneyUnitStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let moneyUnitLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "화폐 단위"
        
        return label
    }()
    
    let moneyUnitButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.moneyUnitButtonPlaceholder, for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 7, bottom: 0, right: 0)
        
        return button
    }()
    
    let moneyUnitExchangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryOrange
        label.font.withSize(Metric.moneyUnitExchangeLabelFontSize)
        label.textAlignment = .right
        label.isHidden = true
        
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    private let categoryLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "카테고리"
    
        return label
    }()
    
    let categoryButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.categoryButtonPlaceholder, for: .normal)
        button.setImage(UIImage(systemName: "c.circle"), for: .normal)

        return button
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        
        return stackView
    }()
    
    
    private let dateLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "날짜"
        
        return label
    }()
    
    let dateButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.dateButtonPlaceholder, for: .normal)
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
        textView.text = StringLiteral.descriptionTextViewPlaceholder
        textView.textColor = .grey3
        textView.font?.withSize(Metric.textViewFontSize)
        textView.backgroundColor = .grey1
        textView.contentInset = Metric.textViewInset
        
        return textView
    }()
    
    let addButton: AddViewCompleteButton = {
        let button = AddViewCompleteButton()
        button.setTitle("지출 추가", for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            titleStackView, amountStackView, moneyUnitStackView, categoryStackView,
            dateStackView, descriptionStackView, addButton
        )
        titleStackView.addArrangedSubviews(titleLabel, titleTextField)
        amountStackView.addArrangedSubviews(amountLabel, amountTextField)
        moneyUnitStackView.addArrangedSubviews(moneyUnitLabel, moneyUnitButton, moneyUnitExchangeLabel)
        categoryStackView.addArrangedSubviews(categoryLabel, categoryButton)
        dateStackView.addArrangedSubviews(dateLabel, dateButton)
        descriptionStackView.addArrangedSubviews(descriptionTitleLabel, descriptionTextView)
        scrollView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(backgroundDidTap)
        ))
    }
    
    private func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        amountStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        amountTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        moneyUnitStackView.snp.makeConstraints {
            $0.top.equalTo(amountStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        moneyUnitButton.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(moneyUnitStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        categoryButton.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(categoryStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateButton.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(40)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func backgroundDidTap() {
        endEditing(true)
    }
}

extension ExpenseAddView {
    enum Metric {
        static let stackViewSpacing: CGFloat = 12
        static let textViewCornerRadius: CGFloat = 10
        static let textViewFontSize: CGFloat = 14
        static let textViewInset: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        static let moneyUnitExchangeLabelFontSize: CGFloat = 9
    }
    
    enum StringLiteral {
        static let titleTextFieldPlaceholder = "지출의 이름을 입력해주세요."
        static let amountTextFieldPlaceholder = "지출 액수를 입력해주세요."
        static let moneyUnitButtonPlaceholder = "화폐 단위를 입력해주세요."
        static let categoryButtonPlaceholder = "카테고리를 입력해주세요."
        static let dateButtonPlaceholder = "날짜를 입력해주세요."
        static let descriptionTextViewPlaceholder = "설명을 입력해주세요."
    }
}
