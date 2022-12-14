//
//  TravelExpenseInfoViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


struct TravelExpenseInfoViewModel: Hashable {
    
    let uuid: UUID
    let travel: TravelInfoViewModel
    let cost: Int
    
    init(uuid: UUID, travel: TravelInfoViewModel, cost: Int) {
        self.uuid = uuid
        self.travel = travel
        self.cost = cost
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}
