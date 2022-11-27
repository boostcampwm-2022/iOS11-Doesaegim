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
            var newTravelInfos: [TravelInfoViewModel] = []
            
            // TODO: - Travel 익스텐션으로
            for travel in travels {
                guard let travelInfo = Travel.convertToViewModel(with: travel) else { continue }
                newTravelInfos.append(travelInfo)
            }
            
            travelInfos.append(contentsOf: newTravelInfos)
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 사용자 에러처리, 알림 등 delegate 메서드 실행
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
                    print(error.localizedDescription)
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 사용자 에러처리, 알림 등 delegate 메서드 실행
        }
        
    }

    func reloadTravelInfo() {

        let number = travelInfos.count
        travelInfos = []
        let result = PersistentManager.shared.fetch(request: Travel.fetchRequest(), offset: 0, limit: number)
        switch result {
        case .success(let travels):
            var newTravelInfos: [TravelInfoViewModel] = []
            for travel in travels {
                guard let travelInfo = Travel.convertToViewModel(with: travel) else { continue }
                newTravelInfos.append(travelInfo)
            }

            travelInfos = newTravelInfos
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 데이터를 불러오지 못했다는 에러처리
        }

    }

}
