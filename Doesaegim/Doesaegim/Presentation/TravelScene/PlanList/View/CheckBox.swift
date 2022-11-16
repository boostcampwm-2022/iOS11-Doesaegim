//
//  CheckBox.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import UIKit

/// 완료 여부를 나타내는 체크 박스 버튼
final class CheckBox: UIButton {

    // MARK: - Prorperties

    /// 초기값: false
    var isChecked: Bool = false {
        didSet {
            toggle()
        }
    }


    // MARK: - Init(s) {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureViews()
    }


    // MARK: - Functions

    private func toggle() {
        tintColor = isChecked ? .primaryOrange : .grey2
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        tintColor = .grey2
        adjustsImageWhenHighlighted = false
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setImage(.init(systemName: StringLiteral.circledCheckmark), for: .normal)
        setPreferredSymbolConfiguration(.init(pointSize: Metric.imagePointSize), forImageIn: .normal)
    }

}


// MARK: - Constants
fileprivate extension CheckBox {

    enum Metric {
        static let imagePointSize: CGFloat = 30
    }

    enum StringLiteral {
        static let circledCheckmark = "checkmark.circle"
    }
}
