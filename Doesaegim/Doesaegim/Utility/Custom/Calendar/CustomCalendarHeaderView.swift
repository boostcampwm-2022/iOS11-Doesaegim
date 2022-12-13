//
//  CustomCalendarHeaderView.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/15.
//

import UIKit

import SnapKit

final class CustomCalendarHeaderView: UICollectionReusableView {
    
    // MARK: - UI properties
    
    private lazy var yearAndMonthLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var backMonthButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "arrowtriangle.left"), for: .normal)
        button.tintColor = .white
        button.tag = -1
        
        return button
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "arrowtriangle.right"), for: .normal)
        button.tintColor = .white
        button.tag = 1
        
        return button
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var weekLabels: [UILabel] = {
        var labels: [UILabel] = []
        
        for weekIndex in 0..<7 {
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 15)
            label.textAlignment = .center
            label.tag = weekIndex
            
            labels.append(label)
        }
        return labels
    }()
    
    private lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Properties
    
    static let identifier = "CustomCalendarHeaderView"
    var buttonHandler: ((Int) -> Void)?
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        backgroundColor = .primaryOrange
        nextMonthButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        backMonthButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configureSubviews() {
        [dateStackView, weekStackView].forEach {
            addSubview($0)
        }
        weekLabels.forEach { weekStackView.addArrangedSubview($0) }
        
        [backMonthButton, yearAndMonthLabel, nextMonthButton].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        backMonthButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        nextMonthButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        weekStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(dateStackView.snp.bottom)
        }
        
    }
    
    func configureUI(date: String, weeks: [String]) {
        yearAndMonthLabel.text = date
        
        for (index, week) in weeks.enumerated() {
            weekLabels[index].text = week
        }
    }
    
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        buttonHandler?(sender.tag)
    }
}
