//
//  UsuarioDataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import CoreData

public class UsuarioDataManager: DataManager, DeleteProtocol {

    public let entityName       = "Usuario"
    
    private let entityMoreToMore = "UsuarioEsportes"
    
    public func adicionar(novo usuarioItem: UsuarioItem) {
        
        let usuario          = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.container.viewContext) as! UsuarioMO
        usuario.nomeCompleto = usuarioItem.nomeCompleto
        usuario.email        = usuarioItem.email
        usuario.dataCadastro = usuarioItem.dataCadastro! as NSDate
        usuario.idFacebook   = usuarioItem.identificadorFacebook
        
        if let foto = usuarioItem.dataImagemFacebook {
            usuario.foto = foto as NSData
        }
        
        
        self.save()
        
    }
    
    public func recuperarUnicoUsuario() -> UsuarioMO? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let result    = try? self.container.viewContext.fetch(fetchRequest) {
            let usuarios = result as! [UsuarioMO]
            return usuarios[0]
        }
        
        return nil
    }
    
    public func recuperarQuantidadeEsportes(favorito: Bool) -> Int {
        
        let fetchRequest       = NSFetchRequest<NSFetchRequestResult>(entityName: entityMoreToMore)
        fetchRequest.predicate = NSPredicate(format: "isFavorito = %@", argumentArray: [favorito])
        
        if let result = try? self.container.viewContext.fetch(fetchRequest) {
            return result.count
        }
        
        return 0
    }
    
    
}
