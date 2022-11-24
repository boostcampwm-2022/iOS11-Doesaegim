//
//  DiaryListCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit

final class DiaryListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = NSStringFromClass(ExpenseListCell.self)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.text = "제목"
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .grey4
        label.text = "날짜날짜날짜날짜"
        
        return label
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 3
        
        return stackView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .grey4
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        stackView.alignment = .leading
        
        return stackView
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.layer.cornerRadius = 7
        
        return imageView
    }()
    
    // MARK: - Initializer(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

extension DiaryListCell {
    
    // MARK: - Configuration
    
    private func configure() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        // stack view
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(dateLabel)
        // 장소 레이블은 추가해야할지 고민
        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(contentLabel)
        
        addSubview(contentStackView)
        addSubview(thumbnailImageView)
    }
    
    private func configureConstraints() {
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(3)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(6)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
    }
    
}
