//
//  TravelPlanControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation

protocol TravelListViewModelProtocol {
    var delegate: TravelListViewModelDelegate? { get set }
    
    var travelInfos: [TravelInfoViewModel] { get set }
    
    func fetchTravelInfo()
    func deleteTravel(with id: UUID)
    
}

protocol TravelListViewModelDelegate: AnyObject {
    func travelListSnapshotShouldChange()
    func travelPlaceholderShouldChange()
}
