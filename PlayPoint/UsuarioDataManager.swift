//
//  UsuarioDataManager.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import CoreData

public class UsuarioDataManager: DataManager {

    let entityName = "Usuario"
    
    public func adicionar(novo usuarioItem: UsuarioItem) {
        
        let usuario          = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.container.viewContext) as! Usuario
        usuario.nomeCompleto = usuarioItem.nomeCompleto
        usuario.email        = usuarioItem.email
        usuario.dataCadastro = usuarioItem.dataCadastro! as NSDate
        usuario.idFacebook   = usuarioItem.identificadorFacebook
        
        if let foto = usuarioItem.dataImagemFacebook {
            usuario.foto = foto as NSData
        }
        
        
        self.save()
        
    }
    
    public func recuperarUnicoUsuario() -> Usuario? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let result    = try? self.container.viewContext.fetch(fetchRequest) {
            let usuarios = result as! [Usuario]
            return usuarios[0]
        }
        
        return nil
    }
    
    public func deletar() -> Bool  {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let result = try? self.container.viewContext.fetch(fetchRequest) {
            for object in result {
                self.container.viewContext.delete(object as! NSManagedObject)
            }
            
            return true
        }
        
        return false
    }
    
}
