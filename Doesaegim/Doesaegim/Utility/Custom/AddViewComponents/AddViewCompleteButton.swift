//
//  AddViewCompleteButton.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import UIKit

final class AddViewCompleteButton: UIButton {
    
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
        setTitleColor(.white, for: .normal)
        backgroundColor = .grey3
        isEnabled = false
        layer.cornerRadius = 10
    }
}
