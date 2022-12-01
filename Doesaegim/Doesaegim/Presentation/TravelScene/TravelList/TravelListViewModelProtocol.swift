//
//  TravelPlanControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/14.
//

import Foundation

protocol TravelListViewModelProtocol {
    var delegate: TravelListViewModelDelegate? { get set }
    
    var travelInfos: [TravelInfoViewModel] { get set }
    
    /// 영구저장소로부터 `Travel`엔티티를 fetch해옵니다.
    func fetchTravelInfo()
    
    /// `UUID`를 파라미터로 받아, 해당 `UUID를 가지는 `Travel` 엔티티의 레코드를 영구저장소로부터 삭제합니다.
    /// - Parameter id: 삭제할 `Travel`엔티티의 `UUID`
    func deleteTravel(with id: UUID)
    
}

protocol TravelListViewModelDelegate: AnyObject {

    /// `TravelListViewModelProtocol`을 준수하는 클래스에서 `travelInfos`에 변화가 생겼을 때 변화를 UI에 반영하기 위해서 호출
    /// 되는 메서드 입니다.
    func travelListSnapshotShouldChange()
    
    /// `TravelListViewModelProtocol`을 준수하는 클래스에서 `travelInfos`에 변화가 생겼을 때, `travelInfos`의 갯수에
    /// 따라서 컬렉션뷰에 나타나는 placeholder의 숨김처리 여부를 결정하는 메서드 입니다. `travelInfos`가 비어있다면 placeholder가
    /// 나타나도록, 비어있지 않다면 숨김처리 하도록 구현해야합니다.
    func travelPlaceholderShouldChange()
    
    /// `TravelListViewModelProtocol`을 준수하는 클래스에서 삭제요청이 실패했을 때 호출되는 메서드 입니다.
    /// 사용자에게 삭제를 실패했다는 알림창을 띄워주도록 구현되어야합니다.
    func travelListDeleteDataDidFail()
    
    /// `TravelListViewModelProtocol`을 준수하는 클래스에서 fetch 요청이 실패했을 때 호출되는 메서드 입니다.
    /// 사용자에게 여행정보 데이터를 불러오는데 실패하였다는 알림창을 띄워주도록 구현되어야합니다.
    func travelListFetchDidFail()
}
