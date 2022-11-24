//
//  DiaryListViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import Foundation

protocol DiaryListViewModelProtocol: AnyObject {
    
    var delegate: DiaryListViewModelDelegate? { get set }
    var diaryInfos: [DiaryInfoViewModel] { get set }
    
    func fetchDiary()
    
}

protocol DiaryListViewModelDelegate: AnyObject {
    
    func diaryInfoDidChage()
    
}
