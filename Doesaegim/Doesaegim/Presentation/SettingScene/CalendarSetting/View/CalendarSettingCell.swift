//
//  CalendarSettingCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import UIKit

final class CalendarSettingCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        accessoryType = .checkmark
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
}

extension CalendarSettingCell {
    
    private func configure() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        contentView.addSubview(label)
    }
    
    private func configureConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
    }
    
    func configureData(with info: CalendarViewModel) {
        label.text = info.title
    }
    
}
