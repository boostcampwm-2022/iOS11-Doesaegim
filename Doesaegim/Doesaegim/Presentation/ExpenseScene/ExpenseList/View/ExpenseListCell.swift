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
    
    let priceLabel: UILabel = {
        let label = UILabel()
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
    
    // MARK: - Configuration
    
    private func configure() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(priceLabel)
    }
    
    private func configureConstraints() {
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing).offset(-12)
        }
    }
    
    func configureContent(with data: ExpenseInfoViewModel) {
        var configuration = self.defaultContentConfiguration()
        configuration.text = data.name
        contentConfiguration = configuration
    }
    
//    private func createContentConfiguration() -> UIContentConfiguration {
//
//    }
    
}
