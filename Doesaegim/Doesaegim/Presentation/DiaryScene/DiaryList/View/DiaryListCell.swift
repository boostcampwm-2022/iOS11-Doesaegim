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
//        label.font = label.font.withSize(16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
        stackView.spacing = 6
        
        return stackView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .grey4
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.isHidden = false
        titleLabel.text = "제목제목제목제목"
        contentLabel.text = "컨텐츠 컨텐츠 컨텐츠"
        dateLabel.text = "날짜 날짜 날짜"
        thumbnailImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureView() {
        layer.cornerRadius = 7
        backgroundColor = .lightRed
        addShadow()
    }
    
    private func configureSubviews() {
        
        // stack view
//        titleStackView.addArrangedSubview(titleLabel)
//        titleStackView.addArrangedSubview(dateLabel)
        // 장소 레이블은 추가해야할지 고민
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(dateLabel)
        
        addSubview(contentStackView)
        addSubview(thumbnailImageView)
    }
    
    private func configureConstraints() {
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(9)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-6)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(-9)
            $0.width.equalTo(45)
            $0.height.equalTo(45)
        }
    }
    
    func configureData(with data: DiaryInfoViewModel) {
        
        titleLabel.text = data.title
        contentLabel.text = data.content
        
        let formatter = Date.yearMonthDayDateFormatter
        let dateString = formatter.string(from: data.date)
        
        dateLabel.text = dateString
        
        if let imageData = data.imageData {
            thumbnailImageView.image = UIImage(data: imageData)
        } else {
            // 섬네일 이미지 뷰를 없앤다. 없어진 constraint를 재설정한다.
            thumbnailImageView.removeFromSuperview()
            contentStackView.snp.makeConstraints {
                // $0.trailing.equalToSuperView().inset(-9) 로 하니 constraint가 잡히지 않습니다.
                $0.trailing.equalTo(self.snp.trailing).offset(-9)
            }
        }
    }
    
    // MARK: - Functions
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.grey4?.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
    }
}