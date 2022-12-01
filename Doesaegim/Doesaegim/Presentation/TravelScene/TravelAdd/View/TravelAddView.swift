//
//  TravelAddView.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/01.
//

import UIKit

final class TravelAddView: UIView {
    
    // MARK: - UI properties
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let travelTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        
        return stackView
    }()
    
    private let travelDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Metric.spacing
        
        return stackView
    }()
    
    private let travelDateLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let travelTitleLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "여행 제목"
        
        return label
    }()
    
    let travelTitleTextField: AddViewTextField = {
        let textField = AddViewTextField()
        textField.placeholder = StringLiteral.travelTitlePlaceholder
        
        return textField
    }()
    
    private let travelDateLabel: AddViewSubtitleLabel = {
        let label = AddViewSubtitleLabel()
        label.text = "날짜"
        
        return label
    }()
    
    let travelDateStartLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey4
        label.clipsToBounds = true
        label.layer.cornerRadius = Metric.cornerRadius
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .grey1
        label.textAlignment = .center
        label.text = StringLiteral.startDateLabelPlaceholder
        return label
    }()
    
    let travelDateEndLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey4
        label.clipsToBounds = true
        label.layer.cornerRadius = Metric.cornerRadius
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .grey1
        label.textAlignment = .center
        label.text = StringLiteral.endDateLabelPlaceholder
        return label
    }()
    
    private let waveLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.backgroundColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("여행 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grey3
        button.isEnabled = false
        button.layer.cornerRadius = Metric.cornerRadius
        
        return button
    }()
    
    let customCalendar: CustomCalendar = {
        let customCalendar = CustomCalendar(
            frame: .zero,
            collectionViewLayout: CustomCalendar.createLayout(),
            touchOption: .double
        )
        return customCalendar
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
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
    
}

extension TravelAddView {
    
    enum StringLiteral {
        static let travelTitlePlaceholder = "여행 제목을 입력해주세요."
        static let startDateLabelPlaceholder = "시작일자"
        static let endDateLabelPlaceholder = "종료일자"
    }
    
    enum Metric {
        static let spacing: CGFloat = 12
        static let cornerRadius: CGFloat = 10
    }
}
