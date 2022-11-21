//
//  PersistentManager.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import CoreData

final class PersistentManager {
    
    // MARK: - Properties
    
    static let shared: PersistentManager = PersistentManager()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Doesaegim")
        _ = container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: 에러처리
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    
    // MARK: - Init(s)
    
    private init() { }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    
    // MARK: - Core Data Fetching support
    
    /// 코어데이터를 불러오기 위한 syntactic sugar
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let items = try context.fetch(request)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    /// NSManagedObject를 상속하는 CoreDataClass를 영구저장소에 요청한다. `offset`번째 레코드부터 최대 `limit`개의 레코드를 배열로 반환한다.
    /// - Parameters:
    ///   - request: Fetch Request
    ///   - offset: 불러올 레코드의 시작 오프셋
    ///   - limit: 불러올 레코드의 최대 갯수
    /// - Returns: `NSManagedObject` 배열
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>, offset: Int, limit: Int) -> [T] {
        do {
            request.fetchOffset = offset
            request.fetchLimit = limit
            let items = try context.fetch(request)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    // MARK: - Core Data Deleting support
    /// TODO: 개발 단계 편의를 위한 메서드로 추후 삭제
    
    /// 엔티티 인스턴스 삭제
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let deleteObject = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteObject)
            return true
        } catch {
            return false
        }
        
    }
    
}
