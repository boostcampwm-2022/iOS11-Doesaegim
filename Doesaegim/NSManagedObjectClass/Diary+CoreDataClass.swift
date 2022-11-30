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

        let location = Location.add(with: object.location)
        diary.location = location
        
        object.travel.addToDiary(diary)
        
        let result = PersistentManager.shared.saveContext()
        
        switch result {
        case .success(let isSuccess):
            if isSuccess {
                return .success(diary)
            }
        case .failure(let error):
            print(error)
            return .failure(error)
        }
        return .failure(CoreDataError.saveFailure(.diary))
    }
    
    static func convertToMapViewModel(with diary: Diary) -> DiaryMapInfoViewModel? {
        guard let id = diary.id,
              let title = diary.title,
              let content = diary.content,
              let date = diary.date,
              let latitude = diary.location?.latitude,
              let longitude = diary.location?.longitude else { return nil }
        
        var imageData: [Data] = []
        if let imagePaths = diary.images {
            imageData = FileProcessManager.shared.fetchImages(with: imagePaths, diaryID: id)
        }
        
        // imagepath의 배열은 이미지가 없는 다이어리가 있을 수 있으므로 따로 검사하지 않는다.
        let diaryMapInfo = DiaryMapInfoViewModel(
            id: id,
            imageData: imageData,
            title: title,
            content: content,
            date: date,
            latitude: latitude,
            longitude: longitude
        )
        
        return diaryMapInfo
    }
    
    static func convertToViewModel(with diary: Diary) -> DiaryInfoViewModel? {
        guard let id = diary.id,
              let title = diary.title,
              let content = diary.content,
              let date = diary.date else { return nil }
                
        var imageData: Data?
        if let imagePath = diary.images?.first {
            let imageDataResult = FileProcessManager.shared.fetchImage(with: imagePath, diaryID: id)
            switch imageDataResult {
            case .success(let data):
                imageData = data
            case .failure(let error):
                print(error.localizedDescription)
                return nil
            }
        }
        
        let diaryInfo = DiaryInfoViewModel(
            id: id,
            content: content,
            date: date,
            imageData: imageData,
            title: title
        )
        
        return diaryInfo
    }
}
