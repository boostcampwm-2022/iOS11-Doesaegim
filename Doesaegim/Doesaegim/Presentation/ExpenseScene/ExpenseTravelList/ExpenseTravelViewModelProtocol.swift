//
//  ExpenseTravelListControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


protocol ExpenseTravelViewModelProtocol {
    
    var delegate: ExpenseTravelViewModelDelegate? { get set }
    
    var travelInfos: [TravelInfoViewModel] { get set }
    
    func fetchTravelInfo()
    
}

protocol ExpenseTravelViewModelDelegate: AnyObject {
    
    func applyTravelSnapshot()
    func applyPlaceholdLabel()
    
}
