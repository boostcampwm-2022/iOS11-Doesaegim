//
//  ExpenseTravelListControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


protocol ExpenseTravelViewModelProtocol: AnyObject {
    
    var delegate: ExpenseTravelViewModelDelegate? { get set }
    var expenseInfos: [TravelExpenseInfoViewModel] { get set }
//    var costs: [Int] { get set }
    
    /// 영구저장소로부터 `Travel`엔티티를 fetch해옵니다.
    func fetchTravelInfo()
}

protocol ExpenseTravelViewModelDelegate: AnyObject {
    
    /// `ExpenseTravelViewModelProtocol`을 준수하는 클래스에서 `travelInfos`에 변화가 생겼을 때 변화를 UI에 반영하기 위해서 호출
    /// 되는 메서드 입니다.
    func travelListSnapshotShouldChange()
    
    /// `ExpenseTravelViewModelProtocol`을 준수하는 클래스에서 `travelInfos`에 변화가 생겼을 때, `travelInfos`의 갯수에
    /// 따라서 컬렉션뷰에 나타나는 placeholder의 숨김처리 여부를 결정하는 메서드 입니다. `travelInfos`가 비어있다면 placeholder가
    /// 나타나도록, 비어있지 않다면 숨김처리 하도록 구현해야합니다.
    func travelPlaceholderShouldChange()
    
    /// `ExpenseTravelViewModelProtocol`을 준수하는 클래스에서 여행정보를 영구저장소로부터 fetch를 실패했을 때 호출되는 메서드 입니다
    /// 사용자에게 여행정보 데이터를 불러오는데에 실패했다는 알림창을 띄워주어야합니다.
    func travelListFetchDidFail()
    
}
