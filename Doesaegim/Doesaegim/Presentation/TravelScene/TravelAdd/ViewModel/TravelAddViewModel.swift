//
//  TravelAddViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import Foundation

final class TravelAddViewModel: TravelAddViewProtocol {
    
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
    
    // MARK: - Lifecycles
    
    init() {
        isValidTextField = false
        isValidDate = false
        isValidInput = isValidTextField && isValidDate
        isClearInput = true
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
              startDate == TravelAddView.StringLiteral.startDateLabelPlaceholder,
              endDate == TravelAddView.StringLiteral.endDateLabelPlaceholder else {
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
        let result = PersistentRepository.shared.fetchTravel()
        switch result {
        case .success(let travels):
            let updateTravels = travels.filter({ $0.id == travel.id })
            guard let updateTravel = updateTravels.last
            else {
                return .failure(CoreDataError.fetchFailure(.travel))
            }
            updateTravel.setValue(name, forKey: "name")
            updateTravel.setValue(startDate, forKey: "startDate")
            updateTravel.setValue(endDate, forKey: "endDate")
            return PersistentManager.shared.saveContext()
            
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(CoreDataError.updateFailure(.travel))
        }
    }
}
