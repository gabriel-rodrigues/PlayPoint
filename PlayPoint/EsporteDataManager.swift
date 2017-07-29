//
//  EsporteDataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import CoreData

public class EsporteDataManager {
    
    public let entityName = "Esporte"
    
    public func recuperarTodos() -> [EsporteMO] {
        
        var esportes = Array<EsporteMO>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "descricao", ascending: true)]
        
        
        if let result = try? DataManager.shared.context.fetch(fetchRequest) {
            esportes = result as! [EsporteMO]
        }
        
        return esportes
    }
    
    
    private func esportesInseridos() -> Bool {
        
        let fetchRequest        = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.resultType = .countResultType
        
        if let result = try? DataManager.shared.context.fetch(fetchRequest) {
            let quantidade = result[0] as! Int
            
            return quantidade > 0
        }
        
        return false
    }

    
    
    public func seedEsportes() {
        
        if !self.esportesInseridos() {
            let esportes = [
                "Atletismo",
                "Badminton",
                "Boxe",
                "Canoagem (slalom e velocidade)",
                "Ciclismo (estrada, pista,BMX eMountain-Bike)",
                "Esgrima",
                "Futebol",
                "Ginástica (artística, rítmica e trampolim)",
                "Golfe",
                "Handebol",
                "Hipismo (salto, CCE, Adestramento)",
                "Hóquei sobre a grama",
                "Judô",
                "Luta (estilo livre, grego-romana)",
                "Maratonas Aquáticas",
                "Nado sincronizado",
                "Natação",
                "Pentatlo moderno",
                "Pólo aquático",
                "Remo",
                "Rugby",
                "Saltos ornamentais",
                "Taekwondo",
                "Tênis",
                "Tênis de mesa",
                "Tiro (com arco esportivo)",
                "Triatlo",
                "Vela",
                "Vôlei",
                "Vôlei de praia"
            ]
            
            for esporte in esportes {
               let esporteMO        = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: DataManager.shared.context) as! EsporteMO
                esporteMO.descricao = esporte
            }
            
            DataManager.shared.save()
        }
        
    }

}
