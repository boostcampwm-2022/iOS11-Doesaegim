//
//  ExpenseTravelViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


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
            
            
            let newTravelInfos = travels.compactMap({ Travel.convertToViewModel(with: $0) })
            var tempTravelInfos = travelInfos
            tempTravelInfos.append(contentsOf: newTravelInfos)
            travelInfos.removeAll() // 하지 않으면 앱의 설정사항이 변경되지 않는다. 한번 삭제한 다음 새로고침 해주어야한다.
            travelInfos = tempTravelInfos
//            travelInfos.append(contentsOf: newTravelInfos)
            
            // 가격 정보 계산
            travels.forEach { travel in
                guard let expenses: [Expense] = travel.expense?.allObjects as? [Expense] else { return }
                let sum = expenses.compactMap({ Expense.convertToViewModel(from: $0)?.cost }).reduce(0, +)
                costs.append(sum)
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListFetchDidFail()
        }
    }
}
