//
//  PlanListViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import Foundation

final class PlanListViewModel {

    // MARK: - Properties

    let navigationTitle: String?

    var viewModelDidChange: ((Bool) -> Void)?

    private(set) var planViewModels = [[PlanViewModel]]()

    private let travel: Travel

    private let repository: PlanRepository

    /// 22.11.16(수) 형태의 날짜를 리턴하는 DateFormatter
    private let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiteral.dateFormat
        return formatter
    }()

    /// 현재 갖고 있는 일정 중 가장 오래된 날짜
    private var lastSection: String? {
        guard let plan = planViewModels.last?.last?.plan,
              let date = plan.date
        else {
            return nil
        }

        return sectionDateFormatter.string(from: date)
    }

    // MARK: - Init(s)

    init(travel: Travel, repository: PlanRepository) {
        self.repository = repository
        self.travel = travel
        self.navigationTitle = travel.name
    }


    // MARK: - Functions

    func title(forSection section: Int) -> String? {
        guard let plan = planViewModels[section].first?.plan,
              let date = plan.date
        else {
            return nil
        }

        return sectionDateFormatter.string(from: date)
    }

    func item(at indexPath: IndexPath, withID id: UUID) -> PlanViewModel? {
        // TODO: Safe Subscript
        let item = planViewModels[indexPath.section][indexPath.row]
        return item.id == id ? item : nil
    }

    func fetch() throws {
        let plans = try repository.fetchPlans(ofTravel: travel)
        convertPlansToPlanViewModelsAndAppend(plans)
        viewModelDidChange?(planViewModels.isEmpty)
    }

    private func convertPlansToPlanViewModelsAndAppend(_ plans: [Plan]) {
        plans.forEach {
            guard let date = $0.date
            else {
                return
            }

            let section = sectionDateFormatter.string(from: date)
            let viewModel = PlanViewModel(plan: $0, repository: repository)

            if section == lastSection {
                planViewModels[planViewModels.count - 1].append(viewModel)
            } else {
                planViewModels.append([viewModel])
            }
        }
    }
}


// MARK: - Constants
fileprivate extension PlanListViewModel {

    enum StringLiteral {
        static let dateFormat = "yy.MM.dd(E)"
    }
}
