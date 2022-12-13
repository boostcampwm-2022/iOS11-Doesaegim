//
//  UICollectionViewCell+.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/13.
//

import UIKit


extension UICollectionViewCell {
    
    public func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.grey2?.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1

    }
    
}
