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
    static func addAndSave(with object: LocationDTO) throws -> Location {
        let context = PersistentManager.shared.context
        let location = Location(context: context)
        location.name = object.name
        location.latitude = object.latitude
        location.longitude = object.longitude
        
        try PersistentManager.shared.saveContext()
        
        return location
    }
}
