//
//  DiaryDetailRepository.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import Foundation

protocol DiaryDetailRepository {
    func getImageDatas(from paths: [String]) -> [Data]?
}
