//
//  DiaryAddViewModelDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/11/22.
//

import Foundation

protocol DiaryAddViewModelDelegate: AnyObject {

    func diaryValuesDidChange(_ diary: TemporaryDiary)
}
