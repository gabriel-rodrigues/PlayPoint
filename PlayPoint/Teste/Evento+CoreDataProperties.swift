//
//  Evento+CoreDataProperties.swift
//  
//
//  Created by Gabriel Rodrigues on 24/07/17.
//
//

import Foundation
import CoreData


extension Evento {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Evento> {
        return NSFetchRequest<Evento>(entityName: "Evento")
    }

    @NSManaged public var dataCriacao: NSDate?
    @NSManaged public var dataInicio: NSDate?
    @NSManaged public var imagem: NSData?
    @NSManaged public var nome: String?
    @NSManaged public var esporte: Esporte?
    @NSManaged public var local: Local?
    @NSManaged public var usuarios: NSSet?

}

// MARK: Generated accessors for usuarios
extension Evento {

    @objc(addUsuariosObject:)
    @NSManaged public func addToUsuarios(_ value: Usuario)

    @objc(removeUsuariosObject:)
    @NSManaged public func removeFromUsuarios(_ value: Usuario)

    @objc(addUsuarios:)
    @NSManaged public func addToUsuarios(_ values: NSSet)

    @objc(removeUsuarios:)
    @NSManaged public func removeFromUsuarios(_ values: NSSet)

}
