//
//  ExpenseTravelViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


final class ExpenseTravelViewModel: ExpenseTravelViewModelProtocol {
    
    var delegate: ExpenseTravelViewModelDelegate?
    
//    var travelInfos: [TravelInfoViewModel] {
//        didSet {
//            delegate?.travelListSnapshotShouldChange()
//            delegate?.travelPlaceholderShouldChange()
//        }
//    }
    
    var expenseInfos: [TravelExpenseInfoViewModel] {
        didSet {
            delegate?.travelListSnapshotShouldChange()
            delegate?.travelPlaceholderShouldChange()
        }
    }
    
//    var costs: [Int]
    
    init() {
        self.expenseInfos = []
//        self.costs = []
    }
    
    func fetchTravelInfo() {
        print("[FETCH TRAVEL INFO START]")
//        let result = PersistentRepository.shared.fetchTravel(offset: travelInfos.count, limit: 10)
        let result = PersistentRepository.shared.fetchTravel()
        expenseInfos.removeAll()
        switch result {
        case .success(let travels):
            
            var newExpenseInfos: [TravelExpenseInfoViewModel] = []
            travels.forEach { travel in
                guard let expenses: [Expense] = travel.expense?.allObjects as? [Expense],
                      let travelInfo = Travel.convertToViewModel(with: travel) else { return }
                
                let sum = expenses.compactMap({ Expense.convertToViewModel(from: $0)?.cost }).reduce(0, +)
                newExpenseInfos.append(
                    TravelExpenseInfoViewModel(
                        uuid: UUID(),
                        travel: travelInfo,
                        cost: sum
                    )
                )
            }
            
            expenseInfos = newExpenseInfos
//            let newTravelInfos = travels.compactMap({ Travel.convertToViewModel(with: $0) })
//            // 가격 정보 계산
//            travels.forEach { travel in
//                guard let expenses: [Expense] = travel.expense?.allObjects as? [Expense] else { return }
//                let sum = expenses.compactMap({ Expense.convertToViewModel(from: $0)?.cost }).reduce(0, +)
//                costs.append(sum)
//                print("\(sum)을 추가하였습니다.")
//            }
//
//            travelInfos = newTravelInfos
            
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListFetchDidFail()
        }
    }
}

extension ExpenseTravelViewModel {
    
    func sortByDate(_ lhs: ExpenseInfoViewModel, _ rhs: ExpenseInfoViewModel) -> Bool {
        return lhs.date > rhs.date
    }
    
}
