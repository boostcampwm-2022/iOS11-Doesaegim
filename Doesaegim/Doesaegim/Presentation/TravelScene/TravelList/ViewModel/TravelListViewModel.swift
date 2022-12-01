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
        
        let result = PersistentRepository.shared.fetchTravel(offset: travelInfos.count, limit: 10)
        switch result {
        case .success(let travels):
            let newTravelInfos = travels.compactMap{ Travel.convertToViewModel(with: $0) }
            travelInfos.append(contentsOf: newTravelInfos)
            
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListFetchDidFail()
        }
        
    }
    
    func deleteTravel(with id: UUID) {
        
        let result = PersistentRepository.shared.fetchTravel()
        switch result {
        case .success(let travels):
            let deleteTravel = travels.filter { $0.id == id }
            if !deleteTravel.isEmpty {
                let deleteResult = PersistentManager.shared.delete(deleteTravel.last!)
                switch deleteResult {
                case .success(let isDeleteComplete):
                    if isDeleteComplete { reloadTravelInfo() }
                case .failure(let error):
                    delegate?.travelListDeleteDataDidFail()
                    print(error.localizedDescription)
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListDeleteDataDidFail()
        }
        
    }

    func reloadTravelInfo() {

        let number = travelInfos.count
        travelInfos = []
        let result = PersistentManager.shared.fetch(request: Travel.fetchRequest(), offset: 0, limit: number)
        switch result {
        case .success(let travels):
            let newTravelInfos = travels.compactMap{ Travel.convertToViewModel(with: $0) }
            travelInfos = newTravelInfos
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListFetchDidFail()
        }

    }

}
