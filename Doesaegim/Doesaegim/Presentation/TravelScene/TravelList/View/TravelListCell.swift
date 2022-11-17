//
//  TravelListCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class TravelListCell: UICollectionViewListCell {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 셀의 기본적인 정보를 설정해주는 메서드
    /// - Parameter identifier: 여행 정보를 가지고 있는 `TravelInfoViewModel` 인스턴스
    func configure(with identifier: TravelInfoViewModel) {
        
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
        contentConfiguration = configuration
    }
    
}
