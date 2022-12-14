//
//  PlanAddViewControllerDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/12/07.
//

import Foundation

/// 새로운 일정이 추가되거나 일정의 내용이 업데이트되었을 때 이를 전달받아 처리
protocol PlanWriteViewControllerDelegate: AnyObject {

    func planWriteViewControllerDidAddPlan(_ plan: Plan)

    func planWriteViewControllerDidUpdatePlan(_ plan: Plan)
}
