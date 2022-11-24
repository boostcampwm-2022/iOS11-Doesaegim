//
//  DiaryInfoViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


struct DiaryInfoViewModel: Hashable {
    
    let id: UUID
    let content: String
    let date: Date
    let image: UIImage? // Data?
    let title: String

    init(id: UUID, content: String, date: Date, image: UIImage?, title: String) {
        self.id = id
        self.content = content
        self.date = date
        self.image = image
        self.title = title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
