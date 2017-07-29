//
//  UsuarioDataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import CoreData

public class UsuarioDataManager : DeleteProtocol {

    public let entityName = "Usuario"
    public let entityEsporte = "Esporte"
    
    
    public func adicionar(novo usuarioItem: UsuarioItem) {
        
        let usuario          = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DataManager.shared.context) as! UsuarioMO
        usuario.nomeCompleto = usuarioItem.nomeCompleto
        usuario.email        = usuarioItem.email
        usuario.dataCadastro = usuarioItem.dataCadastro! as NSDate
        usuario.idFacebook   = usuarioItem.identificadorFacebook
        
        if let foto = usuarioItem.dataImagemFacebook {
            usuario.foto = foto as NSData
        }
        
        
        DataManager.shared.save()
        
    }
    
    public func recuperarUnicoUsuario() -> UsuarioMO? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let result    = try? DataManager.shared.context.fetch(fetchRequest) {
            let usuarios = result as! [UsuarioMO]
            return usuarios[0]
        }
        
        return nil
    }
    
}
