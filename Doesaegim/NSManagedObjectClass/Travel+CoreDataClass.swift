//
//  Travel+CoreDataClass.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//
//

import CoreData
import Foundation


public class Travel: NSManagedObject {
    
    // MARK: - Functions
    
    @discardableResult
    static func addAndSave(with object: TravelDTO) -> Result<Travel, Error> {
        let context = PersistentManager.shared.context
        let travel = Travel(context: context)
        travel.id = object.id
        travel.name = object.name
        travel.startDate = object.startDate
        travel.endDate = object.endDate
        
        let result = PersistentManager.shared.saveContext()
        
        switch result {
        case .success(let isSuccess):
            if isSuccess {
                return .success(travel)
            }
        case .failure(let error):
            return .failure(error)
        }
        return .failure(CoreDataError.saveFailure(.travel))
    }
    
    static func convertToViewModel(with travel: Travel) -> TravelInfoViewModel? {
        
        guard let id = travel.id,
              let title = travel.name,
              let startDate = travel.startDate,
              let endDate = travel.endDate else { return nil }
        
        let travelInfo = TravelInfoViewModel(
            uuid: id,
            title: title,
            startDate: startDate,
            endDate: endDate
        )
        
        return travelInfo
    }


    // MARK: - Fetch Request Functions

    /// 모든 Travel 엔티티를 가져옴
    static func fetchRequest(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> NSFetchRequest<Travel> {

        let request = NSFetchRequest<Travel>(entityName: Travel.name)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return request
    }

    /// 특정 Travel 엔티티의 모든 Plan을 호출하는 리퀘스트로 순서를 지정하지 않으면 종료 날짜 최신순으로로 정렬
    static func endDateSortedFetchRequest() -> NSFetchRequest<Travel> {
        fetchRequest(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "endDate", ascending: false)])
    }
}
