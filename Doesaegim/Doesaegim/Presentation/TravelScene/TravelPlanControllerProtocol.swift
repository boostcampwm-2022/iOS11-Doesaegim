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
    
}

protocol TravelPlanControllerDelegate {
    func applyTravelSnapshot()
}
