//
//  DiaryDetailLocalRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

final class DiaryDetailLocalRepository: DiaryDetailRepository {
    
    private let fileProcessManager = FileProcessManager.shared
    
    private let persistentManager = PersistentManager.shared
    
    /// 이미지 경로들을 통해 파일 시스템에서 해당 파일 데이터를 찾아 반환한다.
    /// - Parameter paths: 이미지 경로 배열
    /// - Returns: 이미지 데이터 배열
    func getImageDatas(from paths: [String], diaryID: UUID) -> [Data]? {
        let images = fileProcessManager.fetchImages(with: paths, diaryID: diaryID)
        return images
    }
    
    /// 특정 id를 받아 다이어리 객체를 반환한다. 문제가 발생할 경우 Error를 반한다.
    /// - Parameter id: 찾으려는 다이어리의 id
    /// - Returns: 다이어리 객체와 Error의 Result 타입
    func getDiaryDetail(with id: UUID) -> Result<Diary, CoreDataError> {
        let result = persistentManager.fetch(request: Diary.fetchRequest())
        
        switch result {
        case .success(let diaries):
            guard let founded = diaries.first(where: { $0.id == id }) else {
                return .failure(.fetchFailure(.diary))
            }
            return .success(founded)
        case .failure:
            return .failure(.fetchFailure(.diary))
        }
    }
}
