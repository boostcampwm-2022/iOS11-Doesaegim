//
//  PlanLocalRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import Foundation

/// 코어데이터를 사용하는 로컬 Plan 저장소
struct PlanLocalRepository: PlanRepository {

    // MARK: - Properties

    let persistentManager = PersistentManager.shared


    // MARK: - CRUD Functions

    func fetchPlans(ofTravelID id: UUID, batchSize: Int) -> Result<[Plan], Error> {
        let request = Plan.fetchRequest(travelID: id)
        request.fetchBatchSize = batchSize
        return persistentManager.fetch(request: request)
    }

    func save() -> Result<Bool, Error> {
        persistentManager.saveContext()
    }

    func deletePlan(_ plan: Plan)  -> Result<Bool, Error> {
        persistentManager.delete(plan)
    }
}
