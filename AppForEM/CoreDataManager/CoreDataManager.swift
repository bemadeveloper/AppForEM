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
    
    private init() {
        persistenContainer = NSPersistentContainer(name: "AppForEM")
        persistenContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistenContainer.viewContext
    }
    
    func fetchTodosCoreData() -> [Todo] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        return (try? context.fetch(request)) ?? []
        
    }
    
    func saveTodos(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            let todosResponse = try decoder.decode(TodosResponse.self, from: jsonData)
            
            for todoJSON in todosResponse.todos {
                let todo = Todo(context: context)
                todo.id = todoJSON.id
                todo.todo = todoJSON.todo
                todo.completed = todoJSON.completed
                todo.userId = todoJSON.userId
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
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Ошибка удаления данных: \(error)")
            }
        }
}
