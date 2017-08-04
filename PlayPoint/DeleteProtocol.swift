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
}


extension DeleteProtocol {
    
    public func deletar() -> Bool  {
        
        let fetch   = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    
        
        if let result = try? DataManager.shared.context.fetch(fetch) {
            
            for objeto in result {
                DataManager.shared.context.delete(objeto as! NSManagedObject)
            }
            
            DataManager.shared.save()
            return true
        }
        
        return false
    }
}
