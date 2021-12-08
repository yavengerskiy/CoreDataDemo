//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Beelab on 08/12/21.
//

import UIKit
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
     
    func updateContext() {
        if getContext().hasChanges {
            do {
                try getContext().save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        StorageManager.shared.persistentContainer.viewContext
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let data = try getContext().fetch(fetchRequest)
            return data
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    func edit(at rowIndex: Int, newValue: String ) {
        let fetchRequest = Task.fetchRequest()
        guard let result = try? getContext().fetch(fetchRequest) else { return }
        
        result[rowIndex].title = newValue
        updateContext()
    }
    
    func delete(at rowIndex: Int) -> Bool{
        let fetchRequest = Task.fetchRequest()
        
        guard let result = try? getContext().fetch(fetchRequest) else { return false }
        
        getContext().delete(result[rowIndex])
        updateContext()
        return true
    }
    
    
    
}
