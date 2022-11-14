//
//  ExpenseDTO.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/14.
//

import Foundation

struct ExpenseDTO {
    let id = UUID()
    let name: String
    let category: String
    let content: String
    let cost: Int64
    let currency: String
    let date: Date
}
