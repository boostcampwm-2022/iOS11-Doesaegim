//
//  PersistentRepositoryProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/19.
//

import Foundation
import CoreData

protocol PersistnetRepositoryProtocol {
    
    /// 엔티티를 영구저장소로부터 패치해온다. 내부에서 request를 생성하고 PersistentManager에 요청을 보낸다.

    func fetchTravel() -> [Travel]
    func fetchExpense() -> [Expense]
    
    /// `NSManagedObject`타입의 엔티티를 영구저장소로부터 불러온다. `offset`번째 레코드부터
    /// 최대 `limit`개의 데이터를 불러온다. 내부에서 request를 생성하고 PersistentManager에
    /// 요청을 보낸다.
    /// - Parameters:
    ///   - offset: 불로어기 시작할 엔티티의 레코드번호
    ///   - limit: 최대로 불러올 수 있는 갯수
    /// - Returns: `NSManagedObject`타입 배열
    ///
    func fetchTravel(offset: Int, limit: Int) -> [Travel]
    func fetchExpense(offset: Int, limit: Int) -> [Expense]
    
    // TODO: - 추후 Result타입 반환하도록 생각
//    /// NSManagedObject를 상속하는 T타입의 엔티티를 영구저장소로부터삭제한다.
//    /// - Parameter with: 삭제할 데이터
//    func delete(type: EntityType)
}
