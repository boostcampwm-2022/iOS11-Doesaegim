//
//  UIStackView+AddArrangedSubviews.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import UIKit

extension UIStackView {

    /// 인자로 들어온 뷰들을 arranged subview로 추가
    ///
    /// - Parameter views: n개의 UIView
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }

    /// 인자로 들어온 뷰들을 arranged subview로 추가
    ///
    /// - Parameter views: UIView의 배열
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
