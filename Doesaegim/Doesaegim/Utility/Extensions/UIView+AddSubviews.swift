//
//  UIView+AddSubviews.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import UIKit

extension UIView {

    /// 인자로 들어온 뷰들을 하위 뷰로 추가
    ///
    /// - Parameter views: n개의 UIView
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    /// 인자로 들어온 뷰들을 하위 뷰로 추가
    ///
    /// - Parameter views: UIView의 배열
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
