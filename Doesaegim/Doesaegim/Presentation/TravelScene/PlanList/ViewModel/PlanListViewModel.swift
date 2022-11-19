//
//  PlanListViewModel.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import Foundation

final class PlanListViewModel {
    typealias SectionAndPlanID = (section: String, planID: UUID)

    // MARK: - Properties

    let navigationTitle: String?

    /// 새로운 일정 데이터가 추가되었을 때 호출하는 클로저
    ///
    /// 새로 추가된 일정의 ID와 섹션ID를 인자로 받음
    var planFetchHandler: (([SectionAndPlanID]) -> Void)?

    /// 일정을 성공적으로 삭제했을 때 호출하는 클로저
    ///
    /// 삭제한 일정의 ID를 인자로 받음
    var planDeleteHandler: ((UUID) -> Void)?

    private(set) var planViewModels = [String: [PlanViewModel]]()
    
    private let repository: PlanRepository
    
    private let travelID: UUID

    private var plans = [Plan]()

    /// 아직 뷰모델로 변환되지 않은 Plan의 시작 인덱스
    private var planOffset = Int.zero

    /// 22.11.16(수) 형태의 날짜를 리턴하는 DateFormatter
    private let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiteral.dateFormat
        return formatter
    }()

    
    // MARK: - Init(s)

    init(travelID: UUID, navgiationTitle: String, repository: PlanRepository) {
        self.repository = repository
        self.travelID = travelID
        self.navigationTitle = navgiationTitle
    }


    // MARK: - Functions

    func item(in section: String, id: UUID) -> PlanViewModel? {
        planViewModels[section]?.first { $0.id == id }
    }


    // MARK: - Plan Fetching Functions

    func fetchPlans() throws {
        // TODO: 디바이스 별로 batchSize 계산하면 더 좋을듯?
        plans = try repository.fetchPlans(ofTravelID: travelID, batchSize: Metric.batchSize)
        let newSectionAndPlanID = convertPlansToPlanViewModelsAndAppend()
        planFetchHandler?(newSectionAndPlanID)
    }

    /// 딕셔너리의 해당 Section키의 배열에 Plan을 PlanViewModel로 변환해서 추가한 후,
    /// 추가한 PlanViewModel들을 섹션 정보와 함께 리턴
    private func convertPlansToPlanViewModelsAndAppend() -> [SectionAndPlanID] {
        var newSectionAndPlanID = [SectionAndPlanID]()

        (Int.zero..<Metric.batchSize).forEach {
            let index = planOffset + $0
            guard plans.indices ~= index,
                  let date = plans[index].date
            else {
                return
            }

            let section = sectionDateFormatter.string(from: date)
            let viewModel = PlanViewModel(plan: plans[index], repository: repository)

            planViewModels[section, default: []].append(viewModel)
            newSectionAndPlanID.append((section, viewModel.id))
        }
        planOffset += Metric.batchSize

        return newSectionAndPlanID
    }


    // MARK: - Plan Deleting Functions

    func deletePlan(in section: String, id: UUID) throws {
        guard let index = planViewModels[section]?.firstIndex(where: { $0.id == id }),
              let planViewModel = planViewModels[section]?[index]
        else {
            return
        }

        try repository.deletePlan(planViewModel.plan)
        planViewModels[section]?.remove(at: index)

        if planViewModels[section]?.isEmpty == true {
            planViewModels[section] = nil
        }
        planDeleteHandler?(planViewModel.id)
    }


    // MARK: - Scroll Detecting Fucntions

    func userDidScrollToEnd() {
        let newSectionAndPlanID = convertPlansToPlanViewModelsAndAppend()
        planFetchHandler?(newSectionAndPlanID)
    }
}


// MARK: - Constants
fileprivate extension PlanListViewModel {

    enum Metric {
        static let batchSize = 20
    }

    enum StringLiteral {
        static let dateFormat = "yy.MM.dd(E)"
    }
}
