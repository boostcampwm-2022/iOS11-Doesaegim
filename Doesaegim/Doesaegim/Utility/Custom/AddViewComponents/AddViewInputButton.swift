//
//  AddViewInputButton.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import UIKit

final class AddViewInputButton: UIButton {
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        layer.cornerRadius = 10
        backgroundColor = .grey1
        setTitleColor(.grey3, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: -5)
        imageEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        tintColor = .grey3
        contentHorizontalAlignment = .left
    }
}
