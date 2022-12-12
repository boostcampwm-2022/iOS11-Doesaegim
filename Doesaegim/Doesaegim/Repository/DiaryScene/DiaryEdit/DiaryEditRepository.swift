//
//  DiaryEditRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/12/12.
//

import Foundation

protocol DiaryEditRepository {

    func fetchAllTravels() -> Result<[Travel], Error>

    func saveDiary() -> Result<Bool, Error>
}
