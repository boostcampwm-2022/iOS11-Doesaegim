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
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryOrange
        imageView.image = UIImage(systemName: "checkmark.square.fill")
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
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
        contentView.addSubview(checkBoxImageView)
    }
    
    private func configureConstraints() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        let checkBoxSize = contentView.frame.size.height / 1.5
        checkBoxImageView.snp.makeConstraints {
            $0.width.height.equalTo(checkBoxSize)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    func configureData(with info: CalendarViewModel, isSelected: Bool) {
        label.text = info.title
        
        checkBoxImageView.isHidden = !isSelected
    }
    
}
