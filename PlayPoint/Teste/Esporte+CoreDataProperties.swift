//
//  Esporte+CoreDataProperties.swift
//  
//
//  Created by Gabriel Rodrigues on 24/07/17.
//
//

import Foundation
import CoreData


extension Esporte {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Esporte> {
        return NSFetchRequest<Esporte>(entityName: "Esporte")
    }

    @NSManaged public var descricao: String?
    @NSManaged public var identificadorImagem: String?
    @NSManaged public var eventos: NSSet?

}

// MARK: Generated accessors for eventos
extension Esporte {

    @objc(addEventosObject:)
    @NSManaged public func addToEventos(_ value: Evento)

    @objc(removeEventosObject:)
    @NSManaged public func removeFromEventos(_ value: Evento)

    @objc(addEventos:)
    @NSManaged public func addToEventos(_ values: NSSet)

    @objc(removeEventos:)
    @NSManaged public func removeFromEventos(_ values: NSSet)

}
