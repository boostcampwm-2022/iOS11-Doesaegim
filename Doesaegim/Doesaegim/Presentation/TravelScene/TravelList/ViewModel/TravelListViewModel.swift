//
//  TempTravelPlanViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation


final class TravelListViewModel: TravelListViewModelProtocol {
    
    var delegate: TravelListViewModelDelegate?
    
    var travelInfos: [TravelInfoViewModel] {
        didSet {
            delegate?.travelListSnapshotShouldChange()
            delegate?.travelPlaceholderShouldChange()
        }
    }
    
    init() {
        travelInfos = []
    }
    
    func fetchTravelInfo() {
        
        let travels = PersistentManager.shared.fetch(
            request: Travel.fetchRequest(),
            offset: travelInfos.count,
            limit: 10
        )
//        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        var newTravelInfos: [TravelInfoViewModel] = []
        
        // TODO: - Travel 익스텐션으로
        for travel in travels {
            guard let travelInfo = Travel.convertToViewModel(with: travel) else { continue }
            newTravelInfos.append(travelInfo)
        }
        
        travelInfos.append(contentsOf: newTravelInfos)
        
    }
    
    func deleteTravel(with id: UUID) {
        print(#function)
        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        let deleteTravel = travels.filter { $0.id == id }
        
        if !deleteTravel.isEmpty {
            PersistentManager.shared.delete(deleteTravel.last!)
            fetchTravelInfo()
        }
    }

}
