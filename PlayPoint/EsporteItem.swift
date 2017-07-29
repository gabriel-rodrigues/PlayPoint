//
//  EsporteItem.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation


public struct EsporteItem {
    
    public var descricao: String
    
    public init (esporte mo: EsporteMO) {
        
        self.descricao = mo.descricao!
    }
}
