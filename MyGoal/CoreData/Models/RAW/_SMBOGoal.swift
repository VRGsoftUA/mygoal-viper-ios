// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMBOGoal.swift instead.

import Foundation
import CoreData

public enum SMBOGoalAttributes: String {
    case categoryID = "categoryID"
    case createDate = "createDate"
    case habit = "habit"
    case identifier = "identifier"
    case lastUpdate = "lastUpdate"
    case notificationTime = "notificationTime"
    case progress = "progress"
    case question = "question"
}

open class _SMBOGoal: SMBOModel {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "SMBOGoal"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _SMBOGoal.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var categoryID: NSNumber?

    @NSManaged open
    var createDate: Date?

    @NSManaged open
    var habit: String?

    @NSManaged open
    var identifier: NSNumber?

    @NSManaged open
    var lastUpdate: Date?

    @NSManaged open
    var notificationTime: Date?

    @NSManaged open
    var progress: NSNumber?

    @NSManaged open
    var question: String?

    // MARK: - Relationships

}

