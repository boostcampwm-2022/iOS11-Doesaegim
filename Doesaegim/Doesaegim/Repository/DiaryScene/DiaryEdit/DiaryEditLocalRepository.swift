//
//  DiaryEditLocalRepository.swift
//  Doesaegim
//
//  Created by sun on 2022/12/12.
//

import Foundation

struct DiaryEditLocalRepository: DiaryEditRepository {


    // MARK: - Properties

    private let persistentManager = PersistentManager.shared


    // MARK: - Functions

    func fetchAllTravels() -> Result<[Travel], Error> {
        let request = Travel.endDateSortedFetchRequest()
        request.fetchBatchSize = Metric.fetchBatchSize

        return persistentManager.fetch(request: request)
    }

    func saveDiary() -> Result<Bool, Error> {
        persistentManager.saveContext()
    }

    func deleteLocation(_ location: Location) -> Result<Bool, Error> {
        persistentManager.delete(location)
    }
}


// MARK: - Constants
fileprivate extension DiaryEditLocalRepository {

    enum Metric {
        static let fetchBatchSize = 10
    }
}
