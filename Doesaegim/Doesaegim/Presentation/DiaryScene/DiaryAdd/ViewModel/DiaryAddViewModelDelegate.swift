//
//  DiaryAddViewModelDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/11/22.
//

import UIKit

protocol DiaryAddViewModelDelegate: AnyObject {
    typealias ImageID = String

    func diaryAddViewModelValuesDidChange(_ diary: TemporaryDiary)

    func diaryAddViewModelDidUpdateSelectedImageIDs(_ identifiers: [ImageID])

    func diaryAddViewModelDidLoadImage(withId id: ImageID)

    func diaryAddViewModelDidAddDiary(_ result: Result<Diary, Error>)
}
