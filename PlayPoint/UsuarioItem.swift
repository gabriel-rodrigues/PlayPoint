//
//  UsuarioItem.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 24/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import SwiftyJSON


public struct UsuarioItem {
    
    public var nomeCompleto: String?
    public var email:String?
    public var dataCadastro: Date?
    public var identificadorFacebook: String?
    public var urlImagemFacebook: String?
    private var data: Data?
    
    public init(jsonFromLoginFacebook: JSON) {
        
        self.nomeCompleto          = jsonFromLoginFacebook["name"].stringValue
        self.dataCadastro          = Date()
        self.email                 = jsonFromLoginFacebook["email"].stringValue
        self.identificadorFacebook = jsonFromLoginFacebook["id"].stringValue
        self.urlImagemFacebook     = jsonFromLoginFacebook["picture"]["data"]["url"].stringValue
    }
    
    public var dataImagemFacebook: Data? {
        
        
        get {
            if data != nil {
                return data
            }
            
            guard let imagemFacebook = self.urlImagemFacebook else {
                return nil
            }
            
            if let url = URL(string: imagemFacebook) {
                
                do {
                    let data = try Data(contentsOf: url)
                    return data
                }
                catch {
                    return nil
                }
            }
            
            return nil
        }
        
        set {
            self.data = newValue
        }
        
        
    }
}
