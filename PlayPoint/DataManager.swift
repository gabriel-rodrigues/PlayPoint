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
    
    public let container: NSPersistentContainer
    
    override init() {
        
        self.container = NSPersistentContainer(name: "Model")
        self.container.loadPersistentStores { (description, error) in
            
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        }
        
        super.init()
    }
    
    func save() {
        
        do {
            if self.container.viewContext.hasChanges {
                try self.container.viewContext.save()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
}
