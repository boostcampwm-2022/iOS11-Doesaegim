//
//  PlanAddRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

protocol PlanAddRepository {
    func addPlan(_ planDTO: PlanDTO) -> Result<Plan, Error>
    func getPlanDetail(with id: UUID?) -> Result<Plan, CoreDataError>
}
