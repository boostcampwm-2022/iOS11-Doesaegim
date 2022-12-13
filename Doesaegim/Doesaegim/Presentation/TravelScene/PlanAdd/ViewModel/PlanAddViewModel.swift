//
//  PlanAddViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/17.
//

import Foundation

final class PlanAddViewModel: PlanAddViewProtocol {
    
    // MARK: - Properties
    
    weak var delegate: PlanAddViewDelegate?
    var isValidInput: Bool {
        didSet {
            delegate?.isVaildInputs(isValid: isValidInput)
        }
    }
    var isValidName: Bool
    var isValidPlace: Bool
    var isValidDate: Bool
    
    var selectedLocation: LocationDTO? {
        didSet {
            guard let selectedLocation = selectedLocation
            else {
                delegate?.planAddViewDidSelectLocation(locationName: "장소를 검색해 주세요.")
                return
            }
            delegate?.planAddViewDidSelectLocation(locationName: selectedLocation.name)
        }
    }
    
    var isClearInput: Bool {
        didSet {
            delegate?.backButtonDidTap(isClear: isClearInput)
        }
    }
    
    let travel: Travel
    private let repository: PlanAddLocalRepository
    var plan: Plan?
    
    // MARK: - Lifecycles
    
    init(travel: Travel, planID: UUID? = nil) {
        isValidName = false
        isValidPlace = false
        isValidDate = false
        isValidInput = isValidName && isValidDate
        isClearInput = true
        repository = PlanAddLocalRepository()
        self.travel = travel
        let result = repository.getPlanDetail(with: planID)
        switch result {
        case .success(let plan):
            self.plan = plan
        case .failure:
            self.plan = nil
        }
    }
    
    // MARK: - Helpers
    
    func isValidPlanName(name: String?) {
        defer {
            isValidInput = isValidName && isValidDate
        }
        guard let name,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidName = false
            return
        }
        isValidName = true
    }

    func isValidDate(dateString: String) {
        defer {
            isValidInput = isValidName && isValidDate
        }
        guard Date.convertDateStringToDate(
            dateString: dateString,
            formatter: Date.yearMonthDayTimeDateFormatter
        ) != nil else {
            isValidDate = false
            return
        }
        isValidDate = true
    }
    
    func postPlan(plan: PlanDTO, completion: @escaping () -> Void) {
        let result = Plan.addAndSave(with: plan)
        switch result {
        case .success:
            completion()
        case .failure(let error):
            print(error.localizedDescription)
            
        }
    }
    
    func isClearInput(title: String?, place: String?, date: String?, description: String?) {
        guard let title, title.isEmpty,
              let place, place == StringLiteral.placeTextPlaceHolder,
              let date, date == StringLiteral.datePlaceHolder,
              let description, description == StringLiteral.descriptionTextViewPlaceHolder else {
            isClearInput = false
            return
        }
        isClearInput = true
    }
    
    func addPlan(
        name: String?,
        dateString: String?,
        locationDTO: LocationDTO?,
        content: String?
    ) -> Result<Plan, Error> {
        guard let name,
              let dateString,
              let date = Date.convertDateStringToDate(
                dateString: dateString,
                formatter: Date.yearMonthDayTimeDateFormatter
              )
        else {
            return .failure(CoreDataError.saveFailure(.plan))
        }
        let planDTO = PlanDTO(
            name: name,
            date: date,
            content: content == StringLiteral.descriptionTextViewPlaceHolder ? "" : (content ?? ""),
            travel: travel,
            location: locationDTO
        )
        
        return repository.addPlan(planDTO)
    }
    
    func dateButtonTapped() {
        delegate?.presentCalendarViewController(travel: travel)
    }
    
    func placeButtonTapped() {
        delegate?.presentSearchingLocationViewController()
    }
    
    func fetchPlan() {
        guard let plan else { return }
        delegate?.configurePlanDetail(plan: plan)
    }
    
    func updatePlan(
        name: String?,
        dateString: String?,
        content: String?
    ) -> Result<Bool, Error> {
        guard let name,
              let dateString,
              let date = Date.yearMonthDayTimeDateFormatter.date(from: dateString),
              let plan else {
            return .failure(CoreDataError.fetchFailure(.plan))
        }
        plan.name = name
        plan.date = date
        
        if plan.location == nil, let locationDTO = selectedLocation {
            let location = Location.add(with: locationDTO)
            plan.location = location
        } else if let planLocation = plan.location, let location = selectedLocation {
            planLocation.name = location.name
            planLocation.latitude = location.latitude
            planLocation.longitude = location.longitude
        } else if let _ = plan.location, selectedLocation == nil {
            plan.location = nil
        }
        plan.content = content
        return PersistentManager.shared.saveContext()
    }
    
    func removeLocation() {
        selectedLocation = nil
    }
}

fileprivate extension PlanAddViewModel {
    enum StringLiteral {
        static let placeTextPlaceHolder = "장소를 검색해 주세요."
        static let datePlaceHolder = "날짜와 시간을 입력해 주세요."
        static let descriptionTextViewPlaceHolder = "설명을 입력해주세요."
    }
}
