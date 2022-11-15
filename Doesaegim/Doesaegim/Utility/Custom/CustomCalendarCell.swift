//
//  CustomCalendarCell.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/15.
//

import UIKit

import SnapKit

final class CustomCalendarCell: UICollectionViewCell {
    
    // MARK: - UI properties
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryOrange
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Properties
    
    static let identifier = "CustomCalendarCell"
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureUI(item: CustomCalendar.Item) {
        dateLabel.text = item.day
    }
}
