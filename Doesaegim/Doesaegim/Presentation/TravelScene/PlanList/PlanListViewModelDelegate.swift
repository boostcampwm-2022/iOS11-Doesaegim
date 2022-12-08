//
//  PlanListViewModelDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/12/07.
//

import Foundation

/// 일정 조회, 추가, 삭제 작업이 발생하면 결과에 대해 알림을 받음
protocol PlanListViewModelDelegate: AnyObject {

    func planListViewModelDidFetchPlans(_ result: Result<[PlanListSnapshotData], Error>)

    func planListViewModelDidDeletePlan(_ result: Result<UUID, Error>)

    func planListViewModelDidAddPlan(_ result: Result<PlanListSnapshotData, Error>)
}
