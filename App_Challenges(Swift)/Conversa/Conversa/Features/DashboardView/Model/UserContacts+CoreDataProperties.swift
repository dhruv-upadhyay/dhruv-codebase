//
//  UserContacts+CoreDataProperties.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//
//

import Foundation
import CoreData

extension UserContacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContacts> {
        return NSFetchRequest<UserContacts>(entityName: "UserContacts")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var userId: UUID?
    @NSManaged public var number: String?
    @NSManaged public var type: String?
    @NSManaged public var relationship: Users?

}

extension UserContacts : Identifiable {

}
