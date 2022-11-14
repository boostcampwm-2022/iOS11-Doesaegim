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

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                // TODO: 에러처리
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
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

    // MARK: - Core Data Deleting support
    /// TODO: 개발 단계 편의를 위한 메서드로 추후 삭제

    /// 엔티티 인스턴스 삭제
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }

}
