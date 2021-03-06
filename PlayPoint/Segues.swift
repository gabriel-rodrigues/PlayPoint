//
//  Segues.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation

internal enum Segue: String {
    
    case showTabBarController     = "showTabBarController"
    case showEsportesFavoritos    = "showEsportesFavoritos"
    case showEsportesInteressados = "showEsportesInteressados"
    case showEscolhaEsporte       = "showEscolhaEsporte"
    case showNovoEvento           = "showNovoEvento"
    case unwindCancelarNovoEvento = "unwindCancelarNovoEvento"
}
