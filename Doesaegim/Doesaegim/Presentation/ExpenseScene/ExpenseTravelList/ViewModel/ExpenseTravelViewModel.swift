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
            
            expenseInfos = newExpenseInfos.sorted(by: sortByDate)
            
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.travelListFetchDidFail()
        }
    }
}

extension ExpenseTravelViewModel {
    
    func sortByDate(_ lhs: TravelExpenseInfoViewModel, _ rhs: TravelExpenseInfoViewModel) -> Bool {
        return lhs.travel.startDate > rhs.travel.startDate
    }
    
}
