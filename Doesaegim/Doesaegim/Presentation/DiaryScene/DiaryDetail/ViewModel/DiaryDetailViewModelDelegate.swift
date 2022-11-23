//
//  DiaryDetailViewModelDelegate.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

protocol DiaryDetailViewModelDelegate: AnyObject {
    
    func fetchDiaryDetail(diary: Diary)
    
    func fetchNavigationTItle(with title: String?)
    
    func fetchImageData(with items: [Data])
    
    func pageControlValueDidChange(to index: Int)
    
}
