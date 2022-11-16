//
//  UITextField+.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/15.
//

import UIKit

extension UITextField {
    func addPadding(witdh: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: witdh, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
