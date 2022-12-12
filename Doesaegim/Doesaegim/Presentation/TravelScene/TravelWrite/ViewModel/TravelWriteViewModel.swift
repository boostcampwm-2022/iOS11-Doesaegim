//
//  TravelWriteViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import Foundation

final class TravelWriteViewModel: TravelWriteViewProtocol {
    
    // MARK: - Properties
    
    private let repository: TravelAddRepository
    
    weak var delegate: TravelAddViewDelegate?
    
    var isValidTextField: Bool
    var isValidDate: Bool
    var isValidInput: Bool {
        didSet {
            delegate?.travelAddFormDidChange(isValid: isValidInput)
        }
    }
    var isClearInput: Bool {
        didSet {
            delegate?.backButtonDidTap(isClear: isClearInput)
        }
    }
    
    private let travel: Travel?
    
    // MARK: - Lifecycles
    
    init(travel: Travel? = nil) {
        isValidTextField = false
        isValidDate = false
        isValidInput = isValidTextField && isValidDate
        isClearInput = true
        self.travel = travel
        repository = TravelAddLocalRepository()
    }
    
    // MARK: - Functions
    
    func travelTitleDidChanged(title: String?) {
        defer { isValidInput = isValidTextField && isValidDate }
        guard let title, !title.isEmpty else {
            isValidTextField = false
            return
        }
        isValidTextField = true
    }
    
    
    func travelDateTapped(dates: [Date], completion: @escaping ((Bool) -> Void)) {
        defer {
            isValidInput = isValidTextField && isValidDate
            completion(isValidDate)
        }
        guard dates.count > 1 else {
            isValidDate = false
            return
        }
        isValidDate = true
        
    }
    
    func isClearInput(title: String?, startDate: String?, endDate: String?) {
        guard let title, title.isEmpty,
              startDate == TravelWriteView.StringLiteral.startDateLabelPlaceholder,
              endDate == TravelWriteView.StringLiteral.endDateLabelPlaceholder else {
            isClearInput = false
            return
        }
        
        isClearInput = true
    }
    
    // MARK: - CoreData Function
    
    func addTravel(name: String?, startDateString: String?, endDateString: String?) -> Result<Travel, Error> {
        guard let name,
              let startDateString,
              let startDate = Date.yearMonthDayDateFormatter.date(from: startDateString),
              let endDateString,
              let endDate = Date.yearMonthDayDateFormatter.date(from: endDateString) else {
            return .failure(CoreDataError.saveFailure(.travel))
        }
        
        let travelDTO = TravelDTO(name: name, startDate: startDate, endDate: endDate)
        return repository.addTravel(travelDTO)
    }
    
    func updateTravel(
        name: String?,
        startDate: Date?,
        endDate: Date?,
        travel: Travel?
    ) -> Result<Bool, Error> {
        guard let travel,
              let name,
              let startDate,
              let endDate else {
            return .failure(CoreDataError.fetchFailure(.travel))
        }
        travel.setValue(name, forKey: "name")
        travel.setValue(startDate, forKey: "startDate")
        travel.setValue(endDate, forKey: "endDate")
        return PersistentManager.shared.saveContext()
    }
}
