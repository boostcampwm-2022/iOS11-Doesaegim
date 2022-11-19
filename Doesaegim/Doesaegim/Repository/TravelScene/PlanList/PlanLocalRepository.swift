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

    func fetchPlans(ofTravelID id: UUID, batchSize: Int) throws -> [Plan] {
        let request = Plan.fetchRequest(travelID: id)
        request.fetchBatchSize = batchSize
        // TODO: 코어데이터 메서드 바꾸자고 하기(에러 던지는 방식으로)
        return persistentManager.fetch(request: request)
    }

    func save() throws {
        try persistentManager.saveContext()
    }

    func deletePlan(_ plan: Plan) throws {
        // TODO: 코어데이터 메서드 바꾸자고 하기(에러 던지는 방식으로)
        persistentManager.delete(plan)
    }
}
