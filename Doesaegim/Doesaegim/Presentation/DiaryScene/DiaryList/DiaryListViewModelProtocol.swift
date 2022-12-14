//
//  DiaryListViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import Foundation

protocol DiaryListViewModelProtocol: AnyObject {
    
    var delegate: DiaryListViewModelDelegate? { get set }
//    var travelSections: [String] { get set }
//    var diaryInfos: [DiaryInfoViewModel] { get set }
//    var sectionDiaryDictionary: [Int: [DiaryInfoViewModel]] { get set }
    var travelDiaryInfos: [TravelDiaryViewModel] { get set }
    
    func fetchDiary()
    func addDummyDiaryData() // 추후 삭제
    
}

protocol DiaryListViewModelDelegate: AnyObject {
    
    func diaryInfoDidChage()
    func diaryListFetchDidFail()
    
}
