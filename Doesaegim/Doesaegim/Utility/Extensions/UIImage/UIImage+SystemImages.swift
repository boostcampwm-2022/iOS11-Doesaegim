//
//  UIImage+SystemImages.swift
//  Doesaegim
//
//  Created by sun on 2022/12/09.
//

import UIKit

extension UIImage {

    // MARK: - Enums

    private enum SystemName: String {
        case xmark
        case basicCheckmark = "checkmark"
    }


    // MARK: - Properties

    static let basicCheckmark = UIImage(systemName: SystemName.basicCheckmark.rawValue)

    static let xmark = UIImage(systemName: SystemName.xmark.rawValue)
}
