//
//  SearchResultCollectionViewCell.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import UIKit

import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Metric.locationNameFontSize)
        label.text = StringLiteral.defaultLocationName
        
        return label
    }()
    
    private let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Metric.locationAddressFontSize)
        label.textColor = .grey4
        label.text = StringLiteral.defaultLocationAddress
        
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.contentStackInsets
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    
    // MARK: - Properties
    
    static let identifier = StringLiteral.identifier
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureLayer()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureLayer() {
        layer.borderWidth = Metric.cellLayerBorderWidth
        layer.borderColor = UIColor.grey1?.cgColor
    }
    
    private func configureSubviews() {
        contentStack.addArrangedSubview(locationNameLabel)
        contentStack.addArrangedSubview(locationAddressLabel)
        
        addSubview(contentStack)
    }
    
    private func configureConstraints() {
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.contentStackInsets)
        }
    }
}

extension SearchResultCollectionViewCell {
    enum Metric {
        static let cellLayerBorderWidth: CGFloat = 1
        
        static let locationNameFontSize: CGFloat = 20
        static let locationAddressFontSize: CGFloat = 16
        
        static let contentStackInsets: CGFloat = 10
    }
    
    enum StringLiteral {
        static let identifier = "SearchResultCollectionViewCell"
        
        static let defaultLocationName = "장소명"
        static let defaultLocationAddress = "주소"
    }
}
