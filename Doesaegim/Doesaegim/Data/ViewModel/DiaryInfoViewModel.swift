//
//  DiaryInfoViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


struct DiaryInfoViewModel: Hashable {
    
    var travelID: UUID?
    let id: UUID
    let content: String
    let date: Date
    var imageData: Data? // Data?
    let title: String

    init(id: UUID, content: String, date: Date, imageData: Data?, title: String) {
        self.id = id
        self.content = content
        self.date = date
        self.imageData = imageData
        self.title = title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
