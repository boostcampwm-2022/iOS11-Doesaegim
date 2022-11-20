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
    
    var isValidTextField: Bool {
        didSet {
            delegate?.isValidView(isVaild: isValidTextField && isValidDate)
        }
    }
    
    var isValidDate: Bool {
        didSet {
            delegate?.isValidView(isVaild: isValidTextField && isValidDate)
        }
    }
    
    // MARK: - Lifecycles
    
    init() {
        isValidTextField = false
        isValidDate = false
    }
    
    // MARK: - CoreData Function
    
    func postTravel(travel: TravelDTO, completion: @escaping (() -> Void)) {
        do {
            try Travel.addAndSave(with: travel)
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
}
