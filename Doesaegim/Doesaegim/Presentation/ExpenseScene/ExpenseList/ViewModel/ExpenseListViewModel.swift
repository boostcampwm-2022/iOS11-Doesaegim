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
        
        let travel = PersistentRepository.shared.fetchTravel(with: id)
        if !travel.isEmpty {
            currentTravel = travel.first!
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
            let dto = ExpenseDTO(
                name: "\(count)번째 지출",
                category: "식비",
                content: "식비입니다 콘텐츠 콘텐츠 콘텐츠",
                cost: 10000,
                currency: "KR",
                date: Date()
            )
            do {
                let expense = try Expense.addAndSave(with: dto)
                travel.addToExpense(expense)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
