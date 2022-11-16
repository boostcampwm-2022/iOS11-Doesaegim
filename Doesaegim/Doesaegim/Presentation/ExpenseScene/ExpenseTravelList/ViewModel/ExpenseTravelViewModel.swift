//
//  ExpenseTravelViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


// TODO: - 여행 목록 불러오기와 비슷한 역할을 하다보니 TravelListViewModel과 완전히 같은 코드가 되어버렸습니다.

final class ExpenseTravelViewModel: ExpenseTravelViewModelProtocol {
    
    var delegate: ExpenseTravelViewModelDelegate?
    
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
        print(#function)
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
        print(travelInfos)
    }
}
