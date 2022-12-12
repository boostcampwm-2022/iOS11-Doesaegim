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
        label.layer.borderColor = UIColor.primaryOrange?.cgColor
        label.textAlignment = .center
        label.layer.cornerRadius = contentView.frame.size.width / 2
        label.clipsToBounds = true
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
    }
    
    func configureUI(item: CustomCalendar.Item) {
        if let date = item.date {
            dateLabel.text = Date.onlyDayDateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        dateLabel.textColor = item.isSunday ? .systemRed : .black
        dateLabel.layer.borderWidth = item.isSelected ? 3 : 0
        if !item.isSelectable {
            dateLabel.textColor = .grey1
        }
        dateLabel.backgroundColor = item.isPeriodDate ? .calendarOrange : .white
        
    }
    
}
