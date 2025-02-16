//
//  Notes+CoreDataProperties.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: Int64
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int64
    @NSManaged public var descriptionOfTask: String?
    @NSManaged public var date: Date?

}

extension Notes {
    static func create(from todoJSON: TodoJSON, context: NSManagedObjectContext) -> Notes {
        let entity = Notes(context: context)
        entity.id = todoJSON.id
        entity.todo = todoJSON.todo
        entity.completed = todoJSON.completed
        entity.userId = todoJSON.userId
        entity.descriptionOfTask = "Описание: #" + String(todoJSON.id)
        entity.date = Self.generateRandomDate()
        print("Созданная дата: \(entity.date)")
        return entity
    }
    
    private static func generateRandomDate() -> Date {
        let randomDaysAgo = Int.random(in: 0...7)
        return Calendar.current.date(byAdding: .day, value: -randomDaysAgo, to: Date()) ?? Date()
    }
}

extension Notes: Identifiable {
    
    
}
