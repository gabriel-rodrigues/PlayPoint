//
//  LoginViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 07/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import SwiftSpinner
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var loginUIButton: UIButton!
    
    private let permissoesFacebook = ["email", "user_birthday", "user_friends"]
    private let parametros         = ["fields": "id, name, first_name, last_name, picture.type(large), email"]
    private let manager            = UsuarioDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let borderAlpha: CGFloat  = 0.7
        let cornerRadius: CGFloat = 5.0
        
        
        loginUIButton.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        loginUIButton.setTitleColor(UIColor.white, for: .normal)
        loginUIButton.backgroundColor    = UIColor.clear
        loginUIButton.layer.borderWidth  = 1.0
        loginUIButton.layer.borderColor  = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        loginUIButton.layer.cornerRadius = cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation */
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*if let tabBarController = segue.destination as? UITabBarController {
            if let navigationController = tabBarController.viewControllers?[0] as? UINavigationController {
                if let controller = navigationController.topViewController as? EventosViewController {

                }
            }
        }*/
    }
    
    
    @IBAction func entrarComFacebook(_ sender: UIButton) {
        
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: self.permissoesFacebook, from: self) { (result, error) in
            if error == nil {
                let facebookLoginResult: FBSDKLoginManagerLoginResult = result!
                
                if facebookLoginResult.grantedPermissions != nil {
                    FBSDKGraphRequest(graphPath: "me", parameters: self.parametros).start(completionHandler: { (connection, result, error) in
                        if error == nil {
                            
                            let usuarioItem = UsuarioItem(jsonFromLoginFacebook: JSON(result!))
                            self.manager.adicionar(novo: usuarioItem)
                            
                            SwiftSpinner.hide()
                            
                            self.performSegue(withIdentifier: Segue.showTabBarController.rawValue, sender: nil)
                        }
                    })
                }
                
            }
        }
        
    }
    
    

}
