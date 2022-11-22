//
//  ExpenseAddView.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/21.
//

import UIKit

final class ExpenseAddView: UIView {
    
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
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지출 이름"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "지출의 이름을 입력해주세요."
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .grey1
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addPadding(witdh: 8)
        return textField
    }()
    
    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지출 액수"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "지출의 액수를 입력해주세요."
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .grey1
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.addPadding(witdh: 8)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var moneyUnitStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var moneyUnitLabel: UILabel = {
        let label = UILabel()
        
        label.text = "화폐 단위"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var moneyUnitButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .grey1
        button.setTitleColor(.grey3, for: .normal)
        button.setTitle("화폐 단위를 입력해주세요.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "dollarsign"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.text = "카테고리"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .grey1
        button.setTitleColor(.grey3, for: .normal)
        button.setTitle("카테고리를 입력해주세요.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "c.circle"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "날짜"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .grey1
        button.setTitleColor(.grey3, for: .normal)
        button.setTitle("날짜를 입력해주세요.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        button.imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        button.tintColor = .grey3
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
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
        textView.text = "설명을 입력해주세요."
        textView.textColor = .grey3
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .grey1
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()

        button.setTitle("지출 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grey3
        button.isEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Properties
    
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
        moneyUnitStackView.addArrangedSubviews(moneyUnitLabel, moneyUnitButton)
        categoryStackView.addArrangedSubviews(categoryLabel, categoryButton)
        dateStackView.addArrangedSubviews(dateLabel, dateButton)
        descriptionStackView.addArrangedSubviews(descriptionTitleLabel, descriptionTextView)
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
}
