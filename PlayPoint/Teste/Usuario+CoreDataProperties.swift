//
//  Usuario+CoreDataProperties.swift
//  
//
//  Created by Gabriel Rodrigues on 24/07/17.
//
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var dataCadastro: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var foto: NSData?
    @NSManaged public var idFacebook: String?
    @NSManaged public var nomeCompleto: String?
    @NSManaged public var eventos: NSSet?

}

// MARK: Generated accessors for eventos
extension Usuario {

    @objc(addEventosObject:)
    @NSManaged public func addToEventos(_ value: Evento)

    @objc(removeEventosObject:)
    @NSManaged public func removeFromEventos(_ value: Evento)

    @objc(addEventos:)
    @NSManaged public func addToEventos(_ values: NSSet)

    @objc(removeEventos:)
    @NSManaged public func removeFromEventos(_ values: NSSet)

}
