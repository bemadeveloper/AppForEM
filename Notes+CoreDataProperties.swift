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

}

extension Notes : Identifiable {

}
