//
//  DiaryAddLocalRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import Foundation

struct DiaryAddLocalRepository: DiaryAddRepository {


    // MARK: - Properties

    private let persistentManager = PersistentManager.shared


    // MARK: - Functions

    func fetchAllTravels() -> Result<[Travel], Error> {
        let request = Travel.fetchRequest()
        request.fetchBatchSize = Metric.fetchBatchSize

        return persistentManager.fetch(request: request)
    }
    
    func addDiary(_ diaryDTO: DiaryDTO) -> Result<Diary, Error> {
        Diary.addAndSave(with: diaryDTO)
    }
}


// MARK: - Constants
fileprivate extension DiaryAddLocalRepository {

    enum Metric {
        static let fetchBatchSize = 10
    }
}
