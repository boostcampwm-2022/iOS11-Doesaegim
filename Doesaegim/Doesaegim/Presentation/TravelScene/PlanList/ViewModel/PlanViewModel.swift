//
//  PlanViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import Foundation

final class PlanViewModel {

    // MARK: - Properties

    let id: UUID

    var isComplete: Bool {
        plan.isComplete
    }

    var name: String? {
        plan.name
    }

    var timeString: String? {
        plan.date?.userDefaultFormattedTime
    }

    var location: String? {
        plan.location?.name
    }

    var content: String? {
        plan.content
    }

    /// 체크박스가 토글되었을 때 호출되는 클로저
    var checkBoxToggleHandler: ((Result<Bool, Error>) -> Void)?

    let plan: Plan

    private let repository: PlanRepository


    // MARK: - Init(s)

    init(plan: Plan, repository: PlanRepository) {
        self.plan = plan
        self.id = plan.id ?? UUID()
        self.repository = repository
    }


    // MARK: - Functions

    /// 체크박스를 탭했을 때 호출
    func checkBoxDidTap() {
        plan.isComplete.toggle()
        let result = repository.save()
        checkBoxToggleHandler?(result)
    }
}
