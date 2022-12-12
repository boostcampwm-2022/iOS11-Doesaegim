//
//  DiaryEditViewModelDelegate.swift
//  Doesaegim
//
//  Created by sun on 2022/12/12.
//

import UIKit

protocol DiaryEditViewModelDelegate: AnyObject {
    typealias ImageID = String

    func diaryEditViewModelValuesDidChange(_ diary: TemporaryDiary)

    func diaryEditViewModelDidUpdateSelectedImageIDs(_ identifiers: [ImageID])

    func diaryEditViewModelDidLoadImage(withID id: ImageID)

    func diaryEditViewModelDidSaveDiary(_ result: Result<Bool, Error>)

    func diaryEditViewModelDidRemoveImage(withID id: ImageID)
}
