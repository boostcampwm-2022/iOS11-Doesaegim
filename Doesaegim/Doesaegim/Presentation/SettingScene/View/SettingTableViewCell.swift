//
//  SettingTableViewCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


import SnapKit

final class SettingTableViewCell: UITableViewCell {
    
    // 네모뷰 안에 감싸보자!
    private let iconContainerView: UIView = {
        let view = UIView()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubviews()
        configureConstraints()
        accessoryType = .disclosureIndicator
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
        // 리셋
        iconImageView.image = nil
        label.text = nil
        iconContainerView.backgroundColor = nil
    }

}

extension SettingTableViewCell {
    
    func configure(with info: SettingOptionViewModel) {
        label.text = info.title
        iconImageView.image = info.icon
        iconContainerView.backgroundColor = info.iconTintColor
    }
    
    private func configureSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
    }
    
    private func configureConstraints() {
        let size = contentView.frame.size.height - 12
        iconContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(6)
            $0.width.height.equalTo(size)
        }
        
        let imageSize = size / 1.5
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
            $0.center.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconContainerView.snp.trailing).offset(15)
        }
    }
    
}
