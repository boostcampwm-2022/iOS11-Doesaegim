//
//  TravelPlanCollectionViewCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import UIKit

final class TravelPlanCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TravelPlanCollectionViewCell"
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configure
    
    func configureConstraints() {
        
    }
    
}
