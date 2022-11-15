//
//  TempTravelPlanViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation


final class TravelPlanViewModel: TravelListControllerProtocol {
    
    var delegate: TravelListControllerDelegate?
    
    var travelInfos: [TravelInfoViewModel] {
        didSet {
            delegate?.applyTravelSnapshot()
        }
    }
    
    init() {
        travelInfos = []
    }
    
    func fetchTravelInfo() {
        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        var newTravelInfos: [TravelInfoViewModel] = []
        
        // TODO: - Travel 익스텐션으로
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
