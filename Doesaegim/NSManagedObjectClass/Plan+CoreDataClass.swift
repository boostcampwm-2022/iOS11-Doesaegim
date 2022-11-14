//
//  Plan+CoreDataClass.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//
//

import CoreData
import Foundation


public class Plan: NSManagedObject {
    
    // MARK: - Functions
    
    @discardableResult
    static func addAndSave(with object: PlanDTO) throws -> Plan {
        let context = PersistentManager.shared.context
        let plan = Plan(context: context)
        plan.id = object.id
        plan.name = object.name
        plan.content = object.content
        plan.date = object.date
        plan.isComplete = object.isComplete
        
        try PersistentManager.shared.saveContext()
        
        return plan
    }
}
