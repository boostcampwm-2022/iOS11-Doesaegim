//
//  ExpenseListViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/19.
//

import Foundation

protocol ExpenseListViewModelProtocol: AnyObject {
    
    var delegate: ExpenseListViewModelDelegate? { get set }
    var expenseInfos: [ExpenseInfoViewModel] { get set }
    var currentTravel: Travel? { get set }
    var sections: [String] { get set }
    
    func fetchCurrentTravel(with travelID: UUID?)
    func fetchExpenseData()
    func addExpenseData() // 추후 제거
    
}

protocol ExpenseListViewModelDelegate: AnyObject {
    
    /// 지출 항목에 변화가 생겼을 때 호출되는 delegate 함수입니다.
    /// `expenseInfos` 데이터를 바탕으로 `UICollectionView`의 스냅샷을 반영하는데에 사용합니다.
    func expenseListDidChanged()
    
    /// ExpenseListViewModelProtocol에서 데이터를 패치 해오는 동작이 실패했을 때 호출되는 메서드
    /// 사용자에게 데이터를 불러오는데 실패하였다는 Aelrt를 보여주어야합니다.
    func expenseListFetchDidFail()
    
}
