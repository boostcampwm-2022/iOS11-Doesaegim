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
    
    var isVaildTextField: Bool {
        didSet {
            delegate?.isVaildView(isVaild: isVaildTextField && isVaildDate)
        }
    }
    
    var isVaildDate: Bool {
        didSet {
            delegate?.isVaildView(isVaild: isVaildTextField && isVaildDate)
        }
    }
    
    // MARK: - Lifecycles
    
    init() {
        isVaildTextField = false
        isVaildDate = false
    }
    
    // MARK: - CoreData Function
    
    func postTravel(travel: TravelDTO, completion: @escaping (() -> Void)) {
        do {
            try Travel.addAndSave(with: travel)
            print("저장완료")
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
}
