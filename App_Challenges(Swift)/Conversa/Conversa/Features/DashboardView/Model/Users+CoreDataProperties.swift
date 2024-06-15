//
//  Users+CoreDataProperties.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//
//

import Foundation
import CoreData

extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var userId: UUID?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var profilePicture: String?
    @NSManaged public var bio: String?
    @NSManaged public var createdAt: Date?

}

extension Users : Identifiable {

}
