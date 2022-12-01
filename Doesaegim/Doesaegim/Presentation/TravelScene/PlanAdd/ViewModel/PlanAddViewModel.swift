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
    
    var isClearInput: Bool {
        didSet {
            delegate?.backButtonDidTap(isClear: isClearInput)
        }
    }
    
    // MARK: - Lifecycles
    
    init() {
        isValidName = false
        isValidPlace = false
        isValidDate = false
        isValidInput = isValidName && isValidPlace && isValidDate
        isClearInput = true
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
    
    func isValidDate(dateString: String) {
        defer {
            isValidInput = isValidName && isValidPlace && isValidDate
        }
        guard let date = Date.convertDateStringToDate(
            dateString: dateString,
            formatter: Date.yearMonthDayTimeDateFormatter
        ) else {
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
}

fileprivate extension PlanAddViewModel {
    enum StringLiteral {
        static let placeTextPlaceHolder = "장소를 검색해 주세요."
        static let datePlaceHolder = "날짜와 시간을 입력해 주세요."
        static let descriptionTextViewPlaceHolder = "설명을 입력해주세요."
    }
}
