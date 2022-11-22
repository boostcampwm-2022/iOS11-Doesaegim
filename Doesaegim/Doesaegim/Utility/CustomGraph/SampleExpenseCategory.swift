//
//  SampleExpenseCategory.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import UIKit

enum SampleExpenseCategory: CaseIterable, CustomStringConvertible {
    case food, transport, shopping, lodgment, etc
    
    var description: String {
        switch self {
        case .food: return "식비"
        case .transport: return "항공비/교통비"
        case .shopping: return "관광비"
        case .lodgment: return "숙박비"
        case .etc: return "기타"
        }
    }
    
    var color: UIColor {
        switch self {
        case .food: return .systemRed
        case .transport: return .systemOrange
        case .shopping: return .systemYellow
        case .lodgment: return .systemGreen
        case .etc: return .systemBlue
        }
    }
}
