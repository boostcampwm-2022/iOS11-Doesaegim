//
//  ExpenseType.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/22.
//

import UIKit

// TODO: - 정수로 관리하고싶음
//enum ExpenseType: Int {
//    case food = 0
//    case transportation = 1
//    case room = 2
//    case other = 3
//}

// MARK: - ExpenseType: 지금은 문자열로 구분

enum ExpenseType: String, CaseIterable {
    case food = "식비"
    case transportation = "교통비"
    case room = "숙박비"
    case shopping = "관광비"
    case other = "기타"
    
    var color: UIColor {
        switch self {
        case .food: return .systemRed
        case .transportation: return .systemOrange
        case .shopping: return .systemYellow
        case .room: return .systemGreen
        case .other: return .systemBlue
        }
    }
}
