//
//  Diary+CoreDataClass.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//
//

import CoreData
import Foundation


public class Diary: NSManagedObject {
    
    // MARK: - Functions
    
    @discardableResult
    static func addAndSave(with object: DiaryDTO) -> Result<Diary, Error> {
        let context = PersistentManager.shared.context
        let diary = Diary(context: context)
        diary.id = object.id
        diary.date = object.date
        diary.images = object.images
        diary.title = object.title
        diary.content = object.content
        
        let result = PersistentManager.shared.saveContext()
        
        switch result {
        case .success(let isSuccess):
            if isSuccess {
                return .success(diary)
            }
        case .failure(let error):
            return .failure(error)
        }
        return .failure(CoreDataError.saveFailure(.diary))
    }
    
    static func convertToMapViewModel(with diary: Diary) -> DiaryMapInfoViewModel? {
        guard let id = diary.id,
              let title = diary.title,
              let content = diary.content else { return nil }
        // imagepath의 배열은 이미지가 없는 다이어리가 있을 수 있으므로 따로 검사하지 않는다.
        let diaryMapInfo = DiaryMapInfoViewModel(
            id: id,
            imagePaths: diary.images,
            title: title,
            content: content
        )
        
        return diaryMapInfo
        
    }
}
