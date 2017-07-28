//
//  EsporteDataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import Foundation
import CoreData

public class EsporteDataManager: DataManager, DeleteProtocol {
    
    public let entityName = "Esporte"
    
    public func recuperarTodos() -> [EsporteItem] {
        
        var esportesItem = Array<EsporteItem>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "descricao", ascending: true)]
        
        
        if let result = try? self.container.viewContext.fetch(fetchRequest) {
            for esporte in result {
                let esporteItem = EsporteItem(esporte: esporte as! EsporteMO)
                esportesItem.append(esporteItem)
            }
        }
        
        return esportesItem
    }
    
    
    public func seedEsportes() {
        
        if self.recuperarTodos().count == 0 {
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
               let esporteMO        = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.container.viewContext) as! EsporteMO
                esporteMO.descricao = esporte
                esporteMO.uuid      = UUID().uuidString
            }
            
            self.save()
        }
        
    }

}
