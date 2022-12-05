//
//  AddViewTextField.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/01.
//

import UIKit

final class AddViewTextField: UITextField {

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
        layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .grey1
        textColor = .black
        font = .systemFont(ofSize: Metric.fontSize, weight: .regular)
        addPadding(witdh: Metric.padding)
    }
}

extension AddViewTextField {
    enum Metric {
        static let cornerRadius: CGFloat = 10
        static let fontSize: CGFloat = 17
        static let padding: CGFloat = 8
    }
}
