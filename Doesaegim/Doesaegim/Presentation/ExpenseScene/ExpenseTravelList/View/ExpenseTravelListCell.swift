//
//  ExpenseTravelListCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseTravelListCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "000,000원"
        label.textColor = .grey4
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    
    private func configureCell() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        addSubview(priceLabel)
    }
    
    private func configureConstraint() {
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing).offset(-6)
        }
    }
    
    func configureContent(with identifier: TravelInfoViewModel) {
        
        contentConfiguration = createContentConfiguration(of: identifier)
    }
    
    private func createContentConfiguration(of identifier: TravelInfoViewModel) -> UIListContentConfiguration {
        
        var configuration = defaultContentConfiguration()
        configuration.image = UIImage(systemName: "airplane.departure")
        configuration.imageProperties.tintColor = .primaryOrange
        configuration.attributedText = NSAttributedString(
            string: identifier.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black!
            ]
        )
        configuration.secondaryAttributedText = NSAttributedString(
            string: Date.convertTravelString(
                start: identifier.startDate,
                end: identifier.endDate
            ),
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.grey4!
                    
            ]
        )
        
        return configuration
    }
    
}
