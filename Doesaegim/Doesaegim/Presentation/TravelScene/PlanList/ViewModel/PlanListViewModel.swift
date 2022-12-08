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

    weak var delegate: PlanListViewModelDelegate?

    private(set) var planViewModels = [String: [PlanViewModel]]()
    
    private let repository: PlanRepository

    /// 데이터베이스에서 가져온 일정
    private var plans = [Plan]()

    /// 유저가 실시간으로 추가한 일정
    ///
    /// 위치를 찾는 과정에서의 불필요한 fault firing을 방지하기 위해 별도로 관리
    private var realTimeAddedPlans = [Plan]()

    /// 아직 뷰모델로 변환되지 않은 Plan의 시작 인덱스
    private var planOffset = Int.zero

    
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
            delegate?.planListViewModelDidFetchPlans(.failure(CoreDataError.fetchFailure(.travel)))
            return
        }
        let result = repository.fetchPlans(ofTravelID: travelID, batchSize: Metric.batchSize)
        switch result {
        case .success(let plans):
            self.plans = plans
            let snapshotData = convertPlansToPlanViewModelsAndAppend()
            guard !snapshotData.isEmpty
            else {
                return
            }
            delegate?.planListViewModelDidFetchPlans(.success(snapshotData))
        case .failure(let error):
            delegate?.planListViewModelDidFetchPlans(.failure(error))
        }
    }

    /// 딕셔너리의 해당 Section키의 배열에 Plan을 PlanViewModel로 변환해서 추가한 후,
    /// 추가한 PlanViewModel들을 섹션 정보와 함께 리턴
    private func convertPlansToPlanViewModelsAndAppend() -> [PlanListSnapshotData] {
        let newPlans = (Int.zero..<Metric.batchSize).compactMap { plans[safeIndex: planOffset + $0] }

        guard !newPlans.isEmpty || !realTimeAddedPlans.isEmpty
        else {
            return []
        }

        let renderedRealTimeAddedPlans = realTimeAddedPlans.filter {
            planShouldBeRendered($0, renderedPlans: newPlans)
        }
        renderedRealTimeAddedPlans.forEach { plan in realTimeAddedPlans.removeAll { $0 == plan } }

        let concatenatedPlans = (newPlans + renderedRealTimeAddedPlans).sorted {
            isLastestPlan(lhs: $0, rhs: $1)
        }
        let snapshotData: [PlanListSnapshotData] = concatenatedPlans.compactMap {
            guard let date = $0.date
            else {
                return nil
            }
            
            let section = date.shortYearMonthDateString
            let viewModel = PlanViewModel(plan: $0, repository: repository)
            planViewModels[section, default: []].append(viewModel)

            return PlanListSnapshotData(section: section, itemID: viewModel.id)
        }

        planOffset += Metric.batchSize

        return snapshotData
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
            delegate?.planListViewModelDidDeletePlan(.success(planViewModel.id))
        case .failure(let error):
            delegate?.planListViewModelDidDeletePlan(.failure(error))
        }
    }


    // MARK: - Scroll Detecting Functions

    func userDidScrollToEnd() {
        let snapshotData = convertPlansToPlanViewModelsAndAppend()
        guard !snapshotData.isEmpty
        else {
            return
        }

        delegate?.planListViewModelDidFetchPlans(.success(snapshotData))
    }


    // MARK: - Plan Adding Functions

    func addNewPlan(_ newPlan: Plan) {
        // TODO: Binary Search
        guard let newPlanDate = newPlan.date
        else {
            delegate?.planListViewModelDidAddPlan(.failure(CoreDataError.fetchFailure(.plan)))
            return
        }

        guard planShouldBeRendered(newPlan, renderedPlans: plans.prefix(planOffset))
        else {
            /// 당장 화면에 나타낼 필요 없는 경우

            realTimeAddedPlans.append(newPlan)
            return
        }
        /// 당장 화면에 나타내야 하는 경우 바로 뷰모델로 변환해서 스냅샷에 반영
        let section = newPlanDate.shortYearMonthDateString
        let viewModel = PlanViewModel(plan: newPlan, repository: repository)
        let viewModelsInSection = planViewModels[section, default: []]
        let row = viewModelsInSection.firstIndex {
            isLastestPlan(lhs: newPlan, rhs: $0.plan)
        } ?? viewModelsInSection.count
        planViewModels[section, default: []].insert(viewModel, at: row)
        let snapshotData = PlanListSnapshotData(section: section, itemID: viewModel.id, row: row)
        delegate?.planListViewModelDidAddPlan(.success(snapshotData))
    }


    // MARK: - Utility Functions

    private func isLastestPlan(lhs: Plan, rhs: Plan) -> Bool {
        guard let lhsDate = lhs.date,
              let rhsDate = rhs.date
        else {
            return false
        }

        return lhsDate > rhsDate
    }

    private func planShouldBeRendered(
        _ targetPlan: Plan,
        renderedPlans: any RandomAccessCollection<Plan>
    ) -> Bool {
        let isLastPlanRendered = !(plans.indices ~= planOffset)
        guard !plans.isEmpty, !isLastPlanRendered
        else {
            return true
        }

        return renderedPlans.firstIndex { isLastestPlan(lhs: targetPlan, rhs: $0) } != nil
    }
}


// MARK: - Constants
fileprivate extension PlanListViewModel {

    enum Metric {
        static let batchSize = 20
    }
}
