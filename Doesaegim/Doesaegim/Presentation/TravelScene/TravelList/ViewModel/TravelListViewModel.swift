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
        
        // TODO: - 한번에 로딩하지 않고 페이지네이션으로 로딩하는 방법을 생각해보자.
        
        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        var newTravelInfos: [TravelInfoViewModel] = []
        
        // TODO: - Travel 익스텐션으로
        for travel in travels {
            guard let travelInfo = Travel.convertToViewModel(with: travel) else { continue }
            newTravelInfos.append(travelInfo)
        }
        
        travelInfos = newTravelInfos
    }
    
    func deleteTravel(with id: UUID) {
        let travels = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        let deleteTravel = travels.filter { $0.id == id }
        
        if !deleteTravel.isEmpty {
            PersistentManager.shared.delete(deleteTravel.last!)
            fetchTravelInfo()
        }
    }
}
