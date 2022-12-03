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
    var sections: [String]
    
    // MARK: - Initializer
    
    init() {
        self.expenseInfos = []
        self.sections = []
    }
}

extension ExpenseListViewModel {
    
    func fetchCurrentTravel(with travelID: UUID?) {
        
        guard let id = travelID else { return }
        
        let result = PersistentRepository.shared.fetchTravel(with: id)
        switch result {
        case .success(let travels):
            if !travels.isEmpty {
                currentTravel = travels.first!
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            // 사용자에게 데이터를 불러오기 실패 알림을 보여준다.
            delegate?.expenseListFetchDidFail()
        }
        
    }
    
    func fetchExpenseData() {

        guard let expenses = currentTravel?.expense?.allObjects as? [Expense] else { return }
        var newExpenses: [ExpenseInfoViewModel] = []
        var newSections: [String] = []
        for expense in expenses {
            guard let viewModel = Expense.convertToViewModel(from: expense) else { continue }
            newExpenses.append(viewModel)
            
            let formatter = Date.yearMonthDayDateFormatter
            let dateString = formatter.string(from: viewModel.date)
            if !newSections.contains(dateString) {
                newSections.append(dateString)
            }
        }
        sections = newSections.sorted(by: sortByDateString)
        expenseInfos = newExpenses.sorted(by: sortByDate)
    }
    
    // 임시로 작성한 메서드. 추후 삭제 더미 지출 데이터를 추가한다.
    func addExpenseData() {

        guard let travel = currentTravel else { return }
        for count in 1...3 {
            let dateComponents = DateComponents(year: 2022, month: 12, day: 25, hour: 17)
            let date = Calendar.current.date(from: dateComponents)!
            let dto = ExpenseDTO(
                name: "\(count)번째 지출",
                category: count == 1 ? "식비" : "교통비",
                content: "식비입니다 콘텐츠 콘텐츠 콘텐츠",
                cost: 10000,
                currency: "KR",
                date: date,
                travel: travel
            )
            
            let result = Expense.addAndSave(with: dto)
            switch result {
            case .success(let expense):
                travel.addToExpense(expense)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

// MARK: - Utility Functions

extension ExpenseListViewModel {
    
    private func sortByDate(_ lhs: ExpenseInfoViewModel, _ rhs: ExpenseInfoViewModel) -> Bool {
        let formatter = Date.yearTominuteFormatterWithoutSeparator
        guard let leftDateValue: Int = Int(formatter.string(from: lhs.date)),
              let rightDateValue: Int = Int(formatter.string(from: rhs.date)) else {
            fatalError("ExpenseListViewModel - sortByDate date 정보를 받지 못했거나 dateFormatter에 이상이 있습니다.")
        }
        
        return leftDateValue < rightDateValue
    }
    
    private func sortByDateString(_ lhs: String, _ rhs: String) -> Bool {
        return lhs > rhs
    }
}
