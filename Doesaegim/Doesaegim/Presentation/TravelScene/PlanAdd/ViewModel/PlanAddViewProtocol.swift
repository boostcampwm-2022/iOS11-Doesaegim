//
//  PlanAddViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/17.
//

import Foundation

protocol PlanAddViewProtocol: AnyObject {
    var delegate: PlanAddViewDelegate? { get set }
    var isValidInput: Bool { get set }
    var isValidName: Bool { get set }
    var isValidPlace: Bool { get set }
    var isValidDate: Bool { get set }
    
    func isValidPlanName(name: String?)
    func isValidPlace(place: LocationDTO?)
    func isValidDate(dateString: String)
    
    func postPlan(plan: PlanDTO, completion: @escaping () -> Void)
}

protocol PlanAddViewDelegate: AnyObject {
    func isVaildInputs(isValid: Bool)
    func planAddViewDidSelectLocation(locationName: String)
}
