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
}
