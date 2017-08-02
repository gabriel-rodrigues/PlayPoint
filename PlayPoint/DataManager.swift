//
//  DataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import CoreData

public class DataManager : NSObject {
    
    private let container = NSPersistentContainer(name: "Model")
    
    public static let shared = DataManager()
    
    override init() {
        

        container.loadPersistentStores { (description, error) in
            
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        }
        
        super.init()
    }
    
    public func save() {
        
        do {
            if self.context.hasChanges {
                try self.context.save()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    public var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    
    
    
    
}
