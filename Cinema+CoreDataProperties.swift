//
//  Cinema+CoreDataProperties.swift
//  Assignment2
//
//  Created by Nicholas on 9/10/2023.
//
//

import Foundation
import CoreData


extension Cinema {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cinema> {
        return NSFetchRequest<Cinema>(entityName: "Cinema")
    }

    @NSManaged public var id: Int32
    @NSManaged public var location: String?
    @NSManaged public var movies: NSSet?

}

// MARK: Generated accessors for movies
extension Cinema {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

extension Cinema : Identifiable {

}
