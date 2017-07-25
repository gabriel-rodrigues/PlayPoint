//
//  Local+CoreDataProperties.swift
//  
//
//  Created by Gabriel Rodrigues on 24/07/17.
//
//

import Foundation
import CoreData


extension Local {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Local> {
        return NSFetchRequest<Local>(entityName: "Local")
    }

    @NSManaged public var latitude: NSDecimalNumber?
    @NSManaged public var longitude: NSDecimalNumber?
    @NSManaged public var nome: String?
    @NSManaged public var evento: Evento?

}
