//
//  Investment+CoreDataProperties.swift
//  PocketBudget
//
//  Created by Pedro Juan Ferreira Saraiva on 01/08/25.
//
//

import Foundation
import CoreData


extension Investment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Investment> {
        return NSFetchRequest<Investment>(entityName: "Investment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var amountInvested: Double
    @NSManaged public var currentValue: Double
    @NSManaged public var date: Date?

}

extension Investment : Identifiable {

}
