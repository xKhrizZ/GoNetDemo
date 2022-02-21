//
//  MovieEntitie+CoreDataProperties.swift
//  
//
//  Created by Christian Rojas on 20/02/22.
//
//

import Foundation
import CoreData


extension MovieEntitie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntitie> {
        return NSFetchRequest<MovieEntitie>(entityName: "MovieEntitie")
    }

    @NSManaged public var data: String?
    @NSManaged public var id: Int16

}
