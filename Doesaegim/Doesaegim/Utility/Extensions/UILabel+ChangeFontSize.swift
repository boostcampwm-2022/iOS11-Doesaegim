//
//  UILabel+ChangeFontSize.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import UIKit

extension UILabel {

    /// 폰트의 사이즈를 인자로 주어진 값으로 변경
    func changeFontSize(to fontSize: CGFloat) {
        font = font.withSize(fontSize)
    }
}
