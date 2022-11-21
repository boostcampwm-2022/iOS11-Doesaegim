//
//  ExpenseListCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseListCell: UICollectionViewListCell {
    
    static let identifier: String = "\(String(describing: ExpenseListCell.self))"
    
    // MARK: - Properties
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "dollarsign.circle")
        imageView.tintColor = .grey3
        return imageView
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.alignment = .leading
        
        return stackView
    }()
    
    let expenseTitle: UILabel = {
        let label = UILabel()
        
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        
        return label
    }()
    
    let expenseDescription: UILabel = {
        let label = UILabel()
        
        label.font = label.font.withSize(12)
        label.textColor = .grey4
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.textColor = .systemRed
        label.font = label.font.withSize(12)
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = UIImage(systemName: "dollarsign.circle")
        priceLabel.text = "-"
    }
    
    // MARK: - Configuration
    
    private func configure() {
        backgroundColor = .white
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(priceLabel)
        addSubview(categoryImageView)
        addSubview(labelStackView)
        
        // stack view
        labelStackView.addArrangedSubview(expenseTitle)
        labelStackView.addArrangedSubview(expenseDescription)
    }
    
    private func configureConstraints() {
        
        categoryImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing).offset(-12)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(6)
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-3)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureContent(with data: ExpenseInfoViewModel) {
        
        configureImageView(with: data.category)
        configureTitle(with: data.name)
        configureDescription(with: data.content)
        configurePrice(with: data.cost)
        
    }
    
    private func configureDescription(with description: String) {
        expenseDescription.text = description
    }
    
    private func configureTitle(with title: String) {
        expenseTitle.text = title
    }
    
    private func configureImageView(with category: String) {
        
        switch category {
        case ExpenseType.food.rawValue:
            categoryImageView.image = UIImage(systemName: "fork.knife")
        case ExpenseType.transportation.rawValue:
            categoryImageView.image = UIImage(systemName: "car")
        case ExpenseType.room.rawValue:
            categoryImageView.image = UIImage(systemName: "bed.double")
        case ExpenseType.other.rawValue:
            categoryImageView.image = UIImage(systemName: "dollarsign.circle")
        default:
            fatalError("잘못된 접근입니다. 지출 추가시 지출 카테고리 문자열을 잘못 설정하였는지 다시 살펴보세요 문자열: [\(category)]")
        }
    }
    
    private func configurePrice(with price: Int) {
        priceLabel.text = price.convertCostString()
    }
}
