//
//  DiaryListHeaderView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


import SnapKit

final class DiaryListHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = NSStringFromClass(DiaryListHeaderView.self)
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "여행 이름"
        
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
        configure()
    }
    
}

extension DiaryListHeaderView {
    
    // MARK: - Configuration
    private func configure() {
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        backgroundColor = .primaryOrange
    }
    
    private func configureSubviews() {
        addSubview(headerLabel)
    }
    
    private func configureConstraints() {
        headerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(6)
        }
    }
    
    func configureData(with travelName: String) {
        headerLabel.text = travelName
    }
    
}
