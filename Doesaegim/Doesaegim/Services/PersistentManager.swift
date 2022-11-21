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
        container.loadPersistentStores(completionHandler: { _, error in
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
    
    func saveContext() -> Result<Bool, Error> {
        if context.hasChanges {
            do {
                try context.save()
                return .success(true)
            } catch let error {
                return .failure(error)
            }
        }
        
        return .success(true)
    }


    // MARK: - Core Data Fetching support

    /// 코어데이터를 불러오기 위한 syntactic sugar
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> Result<[T], Error> {
        do {
            let items = try context.fetch(request)
            return .success(items)
        } catch let error {
            return .failure(error)
        }
    }

    /// NSManagedObject를 상속하는 CoreDataClass를 영구저장소에 요청한다. `offset`번째 레코드부터 최대 `limit`개의 레코드를 배열로 반환한다.
    /// - Parameters:
    ///   - request: Fetch Request
    ///   - offset: 불러올 레코드의 시작 오프셋
    ///   - limit: 불러올 레코드의 최대 갯수
    /// - Returns: `NSManagedObject` 배열
    func fetch<T: NSManagedObject>(
        request: NSFetchRequest<T>,
        offset: Int,
        limit: Int
    ) -> Result<[T], Error> {
        do {
            request.fetchOffset = offset
            request.fetchLimit = limit
            let items = try context.fetch(request)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }

    // MARK: - Core Data Deleting support

    /// 엔티티 인스턴스 삭제
    func delete(_ object: NSManagedObject) -> Result<Bool, Error> {
        context.delete(object)
        do {
            try context.save()
            return .success(true)
        } catch let error {
            return .failure(error)
        }
    }


    // TODO: 개발 단계 편의를 위한 메서드로 추후 삭제
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Result<Bool, Error> {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let deleteObject = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteObject)
            return .success(true)
        } catch let error {
            return .failure(error)
        }

    }

}
