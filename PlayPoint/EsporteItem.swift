//
//  EsporteItem.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import  SwiftyJSON

public struct EsporteItem {
    
    public var descricao: String
    
    public init (esporte mo: EsporteMO) {
        
        self.descricao = mo.descricao!
    }
    
    public init (json esporte: JSON) {
        
        self.descricao = esporte["descricao"].stringValue
    }
}
