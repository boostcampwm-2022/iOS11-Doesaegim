//
//  PlanRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import Foundation

/// Plan 엔티티에 대한 CRUD 작업을 수행하는 저장소
protocol PlanRepository {

    func fetchPlans(ofTravelID id: UUID) throws -> [Plan]

    func save() throws

    func deletePlan(_ plan: Plan) throws
}
