//
//  ExpensePlaceholdView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

import SnapKit

final class ExpensePlaceholdView: UIView {
    
    // MARK: - Properties
    
    private lazy var blurBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return visualEffectView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryOrange
        label.textAlignment = .center
        label.text = "지출 내역이 없어요!"
        
        label.layer.cornerRadius = 7
        label.layer.borderColor = UIColor.primaryOrange?.cgColor
        label.layer.borderWidth = 1
        
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
        configureContstraints()
    }
    
    private func configureSubviews() {
        addSubviews(blurBackgroundView, mainLabel)
    }
    
    private func configureContstraints() {
        mainLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(snp.horizontalEdges).inset(50)
            $0.centerY.equalTo(snp.centerY).multipliedBy(1.3)
            $0.height.equalTo(50)
        }
    }
}
