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
    
    // MARK: - Lifecycles
    
    init() {
        isValidName = false
        isValidPlace = false
        isValidDate = false
//        isValidInput = isValidName && isValidPlace && isValidDate
        isValidInput = isValidName && isValidDate
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
    
    func isValidPlace(place: String?) {
        //
    }
    
    func isValidDate(date: Date?) {
        defer {
            isValidInput = isValidName && isValidDate
        }
        guard let date else {
            isValidDate = false
            return
        }
        isValidDate = true
    }
    
}
