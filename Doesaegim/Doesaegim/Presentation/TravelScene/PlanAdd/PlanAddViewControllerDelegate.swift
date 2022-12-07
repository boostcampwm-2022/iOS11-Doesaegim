//
//  PlanAddViewControllerDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/12/07.
//

import Foundation

/// 새로운 일정이 추가되었을 때 이를 전달받아 처리
protocol PlanAddViewControllerDelegate: AnyObject {

    func planAddViewControllerDidAddPlan(_ plan: Plan)
}
