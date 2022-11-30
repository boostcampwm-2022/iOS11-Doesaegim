//
//  TravelAddViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import Foundation

final class TravelAddViewModel: TravelAddViewProtocol {
    
    // MARK: - Properties
    
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
        guard let title, title.isEmpty else {
            isClearInput = false
            return
        }
        guard let startDate, startDate.isEmpty, let endDate, endDate.isEmpty else {
            isClearInput = false
            return
        }
        isClearInput = true
    }
    
    // MARK: - CoreData Function
    
    func postTravel(travel: TravelDTO, completion: @escaping (() -> Void)) {
        let result = Travel.addAndSave(with: travel)
        switch result {
        case .success:
            completion()
        case .failure(let error):
            print(error.localizedDescription)
            
        }
    }
}
