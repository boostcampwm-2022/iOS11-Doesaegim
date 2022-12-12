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
        case edit = "pencil"
    }


    // MARK: - Inits

    private convenience init?(customSystemName: SystemName) {
        self.init(systemName: customSystemName.rawValue)
    }


    // MARK: - Properties

    static let basicCheckmark = UIImage(customSystemName: .basicCheckmark)

    static let xmark = UIImage(customSystemName: .xmark)

    static let edit = UIImage(customSystemName: .edit)
}
