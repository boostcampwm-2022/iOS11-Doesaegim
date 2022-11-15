//
//  TravelInfoViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation

struct TravelInfoViewModel: Hashable {
    var uuid: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    
    init(uuid: UUID, title: String, startDate: Date, endDate: Date) {
        self.uuid = uuid
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
