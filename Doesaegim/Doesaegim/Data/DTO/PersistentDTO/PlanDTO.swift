//
//  PlanDTO.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/14.
//

import Foundation

struct PlanDTO {
    let id = UUID()
    let name: String
    let date: Date
    let isComplete: Bool = false
    let content: String
    let travel: Travel
    let location: LocationDTO
}
