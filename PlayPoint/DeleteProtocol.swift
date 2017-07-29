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
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        if let _ = try? DataManager.shared.context.execute(request) {
            DataManager.shared.save()
            return true
        }
        
        return false
    }
}
