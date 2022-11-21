//
//  ExpenseInfoViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import Foundation

struct ExpenseInfoViewModel: Hashable {
    
    // TODO: - 카테고리 더 생각해보기...일단 식비로 다 몰아버렷
    enum ExpenseCategory {
        case food
    }
    
    var uuid: UUID // 뺄수있다면 뺀다. -> hash 메서드때문에 못빼려나...?
    var name: String
    var cost: Int
    var content: String
    var category: String
    var date: Date
    
    init(uuid: UUID, name: String, content: String, category: String,cost: Int, date: Date) {
        self.uuid = uuid
        self.name = name
        self.content = content
        self.category = category
        self.cost = cost
        self.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

// TODO: - 정수로 관리하고싶음
//enum ExpenseType: Int {
//    case food = 0
//    case transportation = 1
//    case room = 2
//    case other = 3
//}

// MARK: - ExpenseType: 지금은 문자열로 구분
enum ExpenseType: String {
    case food = "식비"
    case transportation = "교통비"
    case room = "숙박비"
    case other = "기타"
}
