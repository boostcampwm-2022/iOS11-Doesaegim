//
//  LicenseCollectionViewCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import UIKit

final class LicenseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .bottom
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        
        label.font = label.font.withSize(12)
        label.textColor = .grey4
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = label.font.withSize(14)
        label.numberOfLines = 10
        label.textColor = .grey4
        
        return label
    }()
    
    // MARK: - Initializer(s)
    
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
        versionLabel.text = nil
        descriptionLabel.text = nil
    }
    
}

extension LicenseCollectionViewCell {
    
    private func configure() {
        configureView()
        configureSubviews()
        configureConstraints()
        addShadow()
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
    }
    
    private func configureSubviews() {
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(versionLabel)
        
        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(contentStackView)
    }
    
    private func configureConstraints() {
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(9)
            $0.verticalEdges.equalToSuperview().inset(6)
        }
    }
    
    public func configure(with data: LicenseInfoViewModel) {
        
        titleLabel.text = data.name
        versionLabel.text = data.version
        descriptionLabel.text = data.description
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.grey2?.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1

    }
}
