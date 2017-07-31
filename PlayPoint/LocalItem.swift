//
//  LocalItem.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 30/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import MapKit


public struct LocalItem {
    
    public var descricao: String
    public var latitude: Double
    public var longitude: Double
    
    
    public init(markplace: CLPlacemark) {
        
        self.descricao = markplace.name!
        self.latitude  = markplace.location!.coordinate.latitude
        self.longitude = markplace.location!.coordinate.longitude
    }
    
}
