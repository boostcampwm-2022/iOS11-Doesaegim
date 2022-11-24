//
//  DiaryDetailLocalRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import UIKit
// TODO: UIImage 때문에 임시로 import 함ㅠㅠ 추후 Foundation으로 되돌릴 예정

final class DiaryDetailLocalRepository: DiaryDetailRepository {
    private let fileManager = FileManager.default
    
    /// 이미지 경로들을 통해 파일 시스템에서 해당 파일 데이터를 찾아 반환한다.
    /// - Parameter paths: 이미지 경로 배열
    /// - Returns: 이미지 데이터 배열
    func getImageDatas(from paths: [String]) -> [Data]? {
        // TODO: FilManager를 활용해서 해당 경로에 있는 이미지 데이터를 찾아오도록 구현
        // 현재는 path == systemName으로 취급 중
        let images = paths.compactMap {
            UIImage(systemName: $0)?.pngData()
        }
        
        return images
    }
}
