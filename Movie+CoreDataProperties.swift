//
//  Movie+CoreDataProperties.swift
//  Assignment2
//
//  Created by Nicholas on 16/10/2023.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var cast: String?
    @NSManaged public var directors: String?
    @NSManaged public var id: Int32
    @NSManaged public var poster: String?
    @NSManaged public var releaseDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var cinemas: NSSet?

}

// MARK: Generated accessors for cinemas
extension Movie {

    @objc(addCinemasObject:)
    @NSManaged public func addToCinemas(_ value: Cinema)

    @objc(removeCinemasObject:)
    @NSManaged public func removeFromCinemas(_ value: Cinema)

    @objc(addCinemas:)
    @NSManaged public func addToCinemas(_ values: NSSet)

    @objc(removeCinemas:)
    @NSManaged public func removeFromCinemas(_ values: NSSet)

}

extension Movie : Identifiable {

}
