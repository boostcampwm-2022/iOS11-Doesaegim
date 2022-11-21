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
            else { return }
            delegate?.planAddViewDidSelectLocation(locationName: selectedLocation.name)
        }
    }
    
    // MARK: - Lifecycles
    
    init() {
        isValidName = false
        isValidPlace = false
        isValidDate = false
        isValidInput = isValidName && isValidPlace && isValidDate
    }
    
    // MARK: - Helpers
    
    func isValidPlanName(name: String?) {
        defer {
            isValidInput = isValidName && isValidPlace && isValidDate
        }
        guard let name,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValidName = false
            return
        }
        isValidName = true
    }
    
    func isValidPlace(place: LocationDTO?) {
        defer {
            isValidInput = isValidName && isValidPlace && isValidDate
        }
        
        guard let place = place else {
            isValidPlace = false
            return
        }
        selectedLocation = place
        isValidPlace = true
    }
    
    func isValidDate(date: Date?) {
        defer {
            isValidInput = isValidName && isValidPlace && isValidDate
        }
        guard let date else {
            isValidDate = false
            return
        }
        isValidDate = true
    }
    
}
