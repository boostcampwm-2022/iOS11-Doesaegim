//
//  TravelPlanControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation

protocol TravelPlanControllerProtocol {
    var delegate: TravelPlanControllerDelegate? { get set }
    
    var travelInfos: [TravelInfoViewModel] { get set }
    
    func fetchTravelInfo()
    
}

protocol TravelPlanControllerDelegate {
    func applyTravelSnapshot()
}
