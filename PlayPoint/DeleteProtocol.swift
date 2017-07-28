//
//  DeleteProtocol.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import CoreData

public protocol DeleteProtocol {
    
    var entityName: String { get }
    var container: NSPersistentContainer { get }
    
    
    func save()
}


extension DeleteProtocol {
    
    public func deletar() -> Bool  {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let result = try? self.container.viewContext.fetch(fetchRequest) {
            for object in result {
                self.container.viewContext.delete(object as! NSManagedObject)
            }
            
            self.save()
            return true
        }
        
        return false
    }
}
