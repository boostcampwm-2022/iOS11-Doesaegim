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
    var date: Date
    
    init(uuid: UUID, name: String, content: String, cost: Int, date: Date) {
        self.uuid = uuid
        self.name = name
        self.content = content
        self.cost = cost
        self.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
