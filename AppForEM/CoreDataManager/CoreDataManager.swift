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
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func createNewTask(descriptionOfTask: String?, date: Date?, todo: String) {
        let task = Notes(context: context)
        task.descriptionOfTask = descriptionOfTask
        task.date = date
        task.todo = todo
        
        saveContext()
    }
    
    //MARK: - Work with API
    
    func saveTodos(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            let todosResponse = try decoder.decode(TodosResponse.self, from: jsonData)
            
            for todoJSON in todosResponse.todos {
                let todo = Notes.create(from: todoJSON, context: context)
                print("Создан note: \(todo)")
            }
            
            saveContext()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("TodosUpdated"), object: nil)
            }
            print("Данные успешно сохранены")
        } catch {
            print("Ошибка парсинга JSON или сохранения: \(error)")
        }
    }
    
    func fetchTodosCoreData() -> [Notes]? {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        do {
            let tasks = try context.fetch(request)
            print("📌 Найдено сохраненных задач: \(tasks.count)")
            return tasks
        } catch {
            print("❌ Ошибка загрузки данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Notes.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Core Data очищена перед обновлением")
        } catch {
            print("Ошибка очистки Core Data: \(error.localizedDescription)")
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
    
    func updateTask(for id: Int64, newDescription: String, newData: Data, newTodoTask: String) {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let task = try context.fetch(request).first {
                
                task.descriptionOfTask = newDescription
                task.todo = newTodoTask
                task.date = Date()
                
                try context.save()
                print("✅ Изменённые данные успешно сохранены в Core Data!")
                
                let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
                let notes = try context.fetch(fetchRequest)
                print("📌 Всего задач в Core Data: \(notes.count)")
                for note in notes {
                    print("📝 \(note.todo ?? "Без названия") - \(note.descriptionOfTask ?? "")")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("TodosUpdated"), object: nil)
            } else {
                print("⚠️ Задача с id \(id) не найдена.")
            }
        } catch {
            print("❌ Ошибка при обновлении задачи: \(error.localizedDescription)")
        }
    }
    
    func deleteOneTask(id: Int64) {
        if let dataArray = fetchTodosCoreData() {
            context.delete(dataArray[Int(id)])
            saveContext()
        }
    }
}
