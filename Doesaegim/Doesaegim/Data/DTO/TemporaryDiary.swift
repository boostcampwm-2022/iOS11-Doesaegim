//
//  TemporaryDiary.swift
//  Doesaegim
//
//  Created by sun on 2022/11/22.
//

import Foundation

/// DiaryAddViewModel에서 임시로 값을 들고 있기 위한 구조체
struct TemporaryDiary {
    let id = UUID()
    var content: String?
    var date: Date?
    var images: [String]?
    var title: String?
    var location: LocationDTO?
    var travel: Travel?
}
