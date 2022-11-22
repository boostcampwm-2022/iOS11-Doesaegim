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
    
    var costs: [Int]
    
    init() {
        self.travelInfos = []
        self.costs = []
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
            
            // 가격 정보 계산
            for travel in travels {
                guard let expenses: [Expense] = travel.expense?.allObjects as? [Expense] else { continue }
                var sum = 0
                
                for expense in expenses {
                    guard let expenseInfo = Expense.convertToViewModel(from: expense) else { continue }
                    sum += expenseInfo.cost
                }
                costs.append(sum)
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 사용자 에러처리, 알림 등 delegate 메서드 실행
        }
    }
}
