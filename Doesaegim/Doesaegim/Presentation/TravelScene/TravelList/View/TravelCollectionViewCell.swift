//
//  TravelCollectionViewCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import UIKit


import SnapKit

final class TravelCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "globe.asia.australia.fill")
        imageView.tintColor = .primaryOrange
        
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading

        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        label.textColor = .black
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()

        label.font = label.font.withSize(12)
        label.textColor = .grey4
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
}

extension TravelCollectionViewCell {
    
    private func configure() {
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        backgroundColor = .systemBackground
        addShadow()
    }
    
    private func configureSubviews() {
        
        addSubview(imageView)
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureConstraints() {
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(40) // 상대 값보다 고정으로 주는 것이 낫다.
            $0.leading.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(9)
            $0.leading.equalTo(imageView.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(9)
        }
        
//        labelStackView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalTo(imageView.snp.trailing).offset(9)
//            $0.trailing.equalToSuperview().inset(9)
//        }
        
    }
    
    func configure(with data: TravelInfoViewModel) {
        titleLabel.text = data.title
        dateLabel.text = Date.convertTravelString(start: data.startDate, end: data.endDate)
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.grey2?.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 1

    }
    
}
