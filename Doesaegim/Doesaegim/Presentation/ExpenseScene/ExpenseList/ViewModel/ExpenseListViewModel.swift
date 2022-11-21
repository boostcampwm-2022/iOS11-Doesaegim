//
//  ExpenseListViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import Foundation

final class ExpenseListViewModel: ExpenseListViewModelProtocol {
    
    // MARK: - Properties
    
    var delegate: ExpenseListViewModelDelegate?
    var currentTravel: Travel?
    var expenseInfos: [ExpenseInfoViewModel] {
        didSet {
            delegate?.expenseListDidChanged()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        self.expenseInfos = []
    }
}

extension ExpenseListViewModel {
    
    func fetchCurrentTravel(with travelID: UUID?) {
        print(#function)
        guard let id = travelID else { return }
        
        let result = PersistentRepository.shared.fetchTravel(with: id)
        switch result {
        case .success(let travels):
            if !travels.isEmpty {
                currentTravel = travels.first!
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 사용자 에러처리, 알림 등 delegate 메서드 실행
        }
        
    }
    
    func fetchExpenseData() {
//        print(#function)
        guard let expenses = currentTravel?.expense?.allObjects as? [Expense] else { return }
        var newExpenses: [ExpenseInfoViewModel] = []
        for expense in expenses {
            guard let viewModel = Expense.convertToViewModel(from: expense) else { continue }
            newExpenses.append(viewModel)
        }
        expenseInfos.append(contentsOf: newExpenses)
    }
    
    // 임시로 작성한 메서드. 추후 삭제 더미 지출 데이터를 추가한다.
    func addExpenseData() {
//        print(#function)
        guard let travel = currentTravel else { return }
        for count in 1...10 {
            let dateComponents = DateComponents(year: 2022, month: 12, day: 25, hour: 17)
            let date = Calendar.current.date(from: dateComponents)!
            let dto = ExpenseDTO(
                name: "\(count)번째 지출",
                category: "식비",
                content: "식비입니다 콘텐츠 콘텐츠 콘텐츠",
                cost: 10000,
                currency: "KR",
                date: date
            )
            
            let result = Expense.addAndSave(with: dto)
            switch result {
            case .success(let expense):
                travel.addToExpense(expense)
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: 사용자 에러 알림 추가
            }
        }
        
    }
}
