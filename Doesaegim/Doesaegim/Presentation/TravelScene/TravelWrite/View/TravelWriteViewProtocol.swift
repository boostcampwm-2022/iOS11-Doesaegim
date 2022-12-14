//
//  TravelWriteViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import Foundation

protocol TravelWriteViewProtocol: AnyObject {
    var delegate: TravelAddViewDelegate? { get set }
    
    var isValidTextField: Bool { get set }
    var isValidDate: Bool { get set }
    var isValidInput: Bool { get set }
    var isClearInput: Bool { get set }
    
    func travelTitleDidChanged(title: String?)
    func travelDateTapped(dates: [Date], completion: @escaping ((Bool) -> Void))
    
    func addTravel(
        name: String?,
        startDateString: String?,
        endDateString: String?
    ) -> Result<Travel, Error>
}

protocol TravelAddViewDelegate: AnyObject {
    func travelAddFormDidChange(isValid: Bool)
    func backButtonDidTap(isClear: Bool)
}
