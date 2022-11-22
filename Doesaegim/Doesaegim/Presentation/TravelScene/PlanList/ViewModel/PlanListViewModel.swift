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
    
    let travel: Travel

    let navigationTitle: String?

    /// 새로운 일정 데이터가 추가되었을 때 호출하는 클로저
    ///
    /// 새로 추가된 일정의 ID와 섹션ID를 인자로 받음
    var planFetchHandler: ((Result<[SectionAndPlanID], Error>) -> Void)?

    /// 일정을 성공적으로 삭제했을 때 호출하는 클로저
    ///
    /// 삭제한 일정의 ID를 인자로 받음
    var planDeleteHandler: ((Result<UUID, Error>) -> Void)?

    private(set) var planViewModels = [String: [PlanViewModel]]()
    
    private let repository: PlanRepository
    
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

    init(travel: Travel, repository: PlanRepository) {
        self.repository = repository
        self.travel = travel
        self.navigationTitle = travel.name
    }


    // MARK: - Functions

    func item(in section: String, id: UUID) -> PlanViewModel? {
        planViewModels[section]?.first { $0.id == id }
    }


    // MARK: - Plan Fetching Functions

    func fetchPlans() {
        // TODO: 디바이스 별로 batchSize 계산하면 더 좋을듯?
        guard let travelID = travel.id else {
            planFetchHandler?(.failure(CoreDataError.fetchFailure(.travel)))
            return
        }
        let result = repository.fetchPlans(ofTravelID: travelID, batchSize: Metric.batchSize)
        switch result {
        case .success(let plans):
            self.plans = plans
            let newSectionAndPlanID = convertPlansToPlanViewModelsAndAppend()
            planFetchHandler?(.success(newSectionAndPlanID))
        case .failure(let error):
            planFetchHandler?(.failure(error))
        }
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

    func deletePlan(in section: String, id: UUID) {
        guard let index = planViewModels[section]?.firstIndex(where: { $0.id == id }),
              let planViewModel = planViewModels[section]?[index]
        else {
            return
        }

        let result = repository.deletePlan(planViewModel.plan)

        switch result {
        case .success:
            planViewModels[section]?.remove(at: index)
            if planViewModels[section]?.isEmpty == true {
                planViewModels[section] = nil
            }
            planDeleteHandler?(.success(planViewModel.id))
        case .failure(let error):
            planDeleteHandler?(.failure(error))
        }
    }


    // MARK: - Scroll Detecting Fucntions

    func userDidScrollToEnd() {
        let newSectionAndPlanID = convertPlansToPlanViewModelsAndAppend()
        planFetchHandler?(.success(newSectionAndPlanID))
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
