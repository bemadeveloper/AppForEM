//
//  CoreDataManager.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistenContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistenContainer.viewContext
    }
    
    // MARK: - Init
    
    private init() {
        persistenContainer = NSPersistentContainer(name: "AppForEM")
        persistenContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load: \(error)")
            }
        }
    }
    
    // MARK: - CRUD
    
    func createNewTask(id: Int64, todo: String, completed: Bool, userId: Int64, descriptionOfTask: String?, date: Date?) {
        let task = Notes(context: context)
        task.id = id
        task.todo = todo
        task.completed = completed
        task.userId = userId
        task.descriptionOfTask = descriptionOfTask
        task.date = date
        
        saveContext()
    }
    
    func fetchTodosCoreData() -> [Notes] {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func saveTodos(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            let todosResponse = try decoder.decode(TodosResponse.self, from: jsonData)
            
            for todoJSON in todosResponse.todos {
                let todo = Notes.create(from: todoJSON, context: context)
                print("Создан note: \(todo)")
            }
            
            try context.save()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("TodosUpdated"), object: nil)
            }
            print("Данные успешно сохранены")
        } catch {
            print("Ошибка парсинга JSON или сохранения: \(error)")
        }
    }
    
    
    
    func deleteAllTodos() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Notes.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Ошибка удаления данных: \(error)")
            }
        }
}
