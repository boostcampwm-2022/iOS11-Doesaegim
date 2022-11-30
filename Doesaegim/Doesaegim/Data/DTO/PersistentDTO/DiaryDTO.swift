//
//  DiaryDTO.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/14.
//

import Foundation

struct DiaryDTO {
    let id: UUID
    let content: String
    let date: Date
    let images: [String]
    let title: String
    let location: LocationDTO
    let travel: Travel
}
