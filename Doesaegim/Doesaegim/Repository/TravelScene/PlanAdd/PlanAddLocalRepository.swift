//
//  PlanAddLocalRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

struct PlanAddLocalRepository: PlanAddRepository {
    func addPlan(_ planDTO: PlanDTO) -> Result<Plan, Error> {
        Plan.addAndSave(with: planDTO)
    }
    
    
}
