//
//  Location+CoreDataClass.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//
//

import CoreData
import Foundation


public class Location: NSManagedObject {
    
    // MARK: - Functions
    
    @discardableResult
    static func addAndSave(with object: LocationDTO) -> Result<Location, Error> {
        let context = PersistentManager.shared.context
        let location = Location(context: context)
        location.name = object.name
        location.latitude = object.latitude
        location.longitude = object.longitude
        
        let result = PersistentManager.shared.saveContext()
        
        switch result {
        case .success(let isSuccess):
            if isSuccess {
                return .success(location)
            }
        case .failure(let error):
            return .failure(error)
        }
        return .failure(CoreDataError.saveFailure(.location))
    }
}
