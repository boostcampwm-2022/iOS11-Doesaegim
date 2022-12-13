//
//  SettingSwitchCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import UIKit


import SnapKit

final class SettingSwitchCell: UITableViewCell {
    
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
    
    private let controlSwitch: UISwitch = {
        let control = UISwitch()
        
        control.onTintColor = .primaryOrange
        
        return control
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubviews()
        configureConstraints()
        accessoryType = .none
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

extension SettingSwitchCell {
    
    func configure(with info: SettingOptionViewModel) {
        
        guard let key = info.switchKey else { return }
        
        label.text = info.title
        iconImageView.image = info.icon
        iconContainerView.backgroundColor = info.iconTintColor
        
        if let isOn = UserDefaults.standard.object(forKey: key) as? Bool {
            controlSwitch.isOn = isOn
        } else {
            UserDefaults.standard.set(false, forKey: key)
            controlSwitch.isOn = false
        }
        
        controlSwitch.addAction(UIAction(handler: { _ in
            info.handler()
            UserDefaults.standard.setValue(self.controlSwitch.isOn, forKey: key)
            
            // TODO: - 추후 알림 기능이 개발되면 제거될 코드
            self.controlSwitch.isOn = false
            UserDefaults.standard.setValue(false, forKey: key)
            //
            
        }), for: .valueChanged)
    }
    
    private func configureSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(iconContainerView)
        contentView.addSubview(controlSwitch)
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
        
        controlSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
    }
    
}
