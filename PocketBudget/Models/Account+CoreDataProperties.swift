//
//  Account+CoreDataProperties.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 29/07/25.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var dueDate: Date?
    @NSManaged public var isPaid: Bool

}

extension Account : Identifiable {

}
