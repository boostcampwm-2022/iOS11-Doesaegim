//
//  SearchingLocationViewControllerDelegate.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import Foundation

protocol SearchingLocationViewControllerDelegate: AnyObject {
    /// 선택한 장소 정보를 다른 화면 (일정 추가 화면, 다이어리 작성 화면 등)으로 보낼 때 구현해 사용할 수 있습니다.
    func searchingLocationViewController(didSelect location: LocationDTO)
}
