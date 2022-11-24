//
//  DiaryAddRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import Foundation

protocol DiaryAddRepository {

    func fetchAllTravels() -> Result<[Travel], Error>

    func addDiary(_ diaryDTO: DiaryDTO) -> Result<Diary, Error> 
}
