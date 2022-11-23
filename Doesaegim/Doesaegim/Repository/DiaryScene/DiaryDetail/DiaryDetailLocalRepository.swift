//
//  DiaryDetailLocalRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

final class DiaryDetailLocalRepository: DiaryDetailRepository {
    private let fileManager = FileManager.default
    
    /// 이미지 경로들을 통해 파일 시스템에서 해당 파일 데이터를 찾아 반환한다.
    /// - Parameter paths: 이미지 경로 배열
    /// - Returns: 이미지 데이터 배열
    func getImageDatas(from paths: [String]) -> [Data]? {
        
        return nil
    }
}
