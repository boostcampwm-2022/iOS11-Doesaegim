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
}
