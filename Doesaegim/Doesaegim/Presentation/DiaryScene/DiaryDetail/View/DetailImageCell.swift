//
//  DetailImageCell.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    // MARK: - UI Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Functions
    
    func setupImage(image: UIImage?) {
        imageView.image = image
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        addSubview(imageView)
    }
    
    private func configureConstraint() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
