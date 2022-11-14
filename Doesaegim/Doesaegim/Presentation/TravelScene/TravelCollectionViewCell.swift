//
//  TravelPlanCollectionViewCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import UIKit

final class TravelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TravelPlanCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 9
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .grey4
        
        return label
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureStackView()
        configureSubviews()
        configureConstraints()
    }
    
    // MARK: - Configure
    
    func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func configureSubviews() {
        addSubview(stackView)
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func configureLabel(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}
