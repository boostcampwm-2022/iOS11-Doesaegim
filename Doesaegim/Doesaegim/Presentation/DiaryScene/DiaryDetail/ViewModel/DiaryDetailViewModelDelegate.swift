//
//  DiaryDetailViewModelDelegate.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

protocol DiaryDetailViewModelDelegate: AnyObject {
    
    func diaryDetailTitleDidFetch(with title: String?)
    
    func diaryDetailDidFetch(diary: Diary)
    
    func diaryDetailImageSliderPagesDidFetch(_ count: Int)
    
    func diaryDetailImageSliderDidRefresh()
    
}
