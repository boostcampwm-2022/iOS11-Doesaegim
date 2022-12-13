//
//  ExpenseSectionHeader.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseSectionHeaderView: UICollectionReusableView {
    
    static let reusableID: String = String(describing: ExpenseSectionHeaderView.self)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "날짜"
        
        
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
    
    private func configure() {
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureView() {
        
        backgroundColor = .primaryOrange
        layer.cornerRadius = 10
    }
    
    private func configureSubviews() {
        addSubview(dateLabel)
    }
    
    private func configureConstraints() {
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(6)
        }
    }
    
    func configureData(dateString: String?) {
        guard let dateString else { return }
        
        dateLabel.text = dateString
    }
}
