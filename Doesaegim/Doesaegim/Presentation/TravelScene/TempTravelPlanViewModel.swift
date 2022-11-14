//
//  TempTravelPlanViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation


final class TempTravelPlanViewModel: TravelPlanControllerProtocol {
    
    var delegate: TravelPlanControllerDelegate?
    
    var travelInfos: [TravelInfoViewModel] {
        didSet {
            delegate?.applyTravelSnapshot()
        }
    }
    
    init() {
        travelInfos = []
    }
    
    func fetchTravelData() {
        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        var newTravelInfos: [TravelInfoViewModel] = []
        
        for travel in travels {
            if let id = travel.id,
               let title = travel.name,
               let startDate = travel.startDate,
               let endDate = travel.endDate {
                let travelInfo = TravelInfoViewModel(
                    uuid: id,
                    title: title,
                    startDate: startDate,
                    endDate: endDate
                )
                newTravelInfos.append(travelInfo)
            }
        }
        
        travelInfos = newTravelInfos
    }
    
    
}
