//
//  AddViewSubtitleLabel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/01.
//

import UIKit

final class AddViewSubtitleLabel: UILabel {
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        textColor = .black
        font = .systemFont(ofSize: 20, weight: .bold)
        textAlignment = .left
    }
}
