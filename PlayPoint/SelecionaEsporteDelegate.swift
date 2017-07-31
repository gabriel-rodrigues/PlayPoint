//
//  SelecionaEsporteProtocol.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 30/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation


public protocol SelecionaEsporteDelegate {
    
    func selecionar(esporte: EsporteMO)
    
    var esporteSelecionado: EsporteMO? { get set }

}
