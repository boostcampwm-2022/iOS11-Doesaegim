//
//  ExpensePlaceholdView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpensePlaceholdView: UIView {
    
    // MARK: - Properties
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryOrange
        label.text = "지출 내역이 없어요!"
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureSubviews()
        configureStyle()
        configureContstraints()
    }
    
    private func configureSubviews() {
        addSubview(mainLabel)
    }
    
    private func configureStyle() {
        backgroundColor = .white
        layer.cornerRadius = 7
        layer.borderColor = UIColor.primaryOrange?.cgColor
        layer.borderWidth = 1
    }
    
    private func configureContstraints() {
        mainLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
}
