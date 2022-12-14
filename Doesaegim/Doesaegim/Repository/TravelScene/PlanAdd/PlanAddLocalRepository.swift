//
//  PlanAddLocalRepository.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

struct PlanAddLocalRepository: PlanAddRepository {
    
    private let persistentManager = PersistentManager.shared
    
    func addPlan(_ planDTO: PlanDTO) -> Result<Plan, Error> {
        Plan.addAndSave(with: planDTO)
    }
    
    func getPlanDetail(with id: UUID?) -> Result<Plan, CoreDataError> {
        guard let id else { return .failure(.fetchFailure(.plan))}
        let result = persistentManager.fetch(request: Plan.fetchRequest())
        
        switch result {
        case .success(let plans):
            guard let plan = plans.first(where: { $0.id == id }) else {
                return .failure(.fetchFailure(.plan))
            }
            return .success(plan)
        case .failure:
            return .failure(.fetchFailure(.plan))
        }
    }
}
