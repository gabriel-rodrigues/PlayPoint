//
//  PerfilTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 04/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class PerfilTableViewController: UITableViewController {

    let manager = UsuarioDataManager()
    
    @IBOutlet weak var fotoImagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var usuarioDesdeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var quantidadeFavoritosLabel: UILabel!
    @IBOutlet weak var quantidadeInteressadosLabel: UILabel!
    @IBOutlet weak var quantidadeEventosMeusLabel: UILabel!
    @IBOutlet weak var quantidadeEventosConfirmadosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let usuario = manager.recuperarUnicoUsuario()!
        
        self.fotoImagemView.image = UIImage(data: usuario.foto! as Data)
        self.fotoImagemView.layer.cornerRadius = fotoImagemView.frame.size.width / 2
        self.fotoImagemView.clipsToBounds = true
        self.nomeLabel.text       = usuario.nomeCompleto
        self.emailLabel.text      = usuario.email
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        self.usuarioDesdeLabel.text = dataFormatter.string(from: usuario.dataCadastro! as Date)
        
        
        self.arredonarLabelsQuantidades()
    }
    
    func arredonarLabelsQuantidades() {
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 && indexPath.row == 0 {
            self.confirmaLogOut()
        }
    }
    
    func confirmaLogOut()  {
        
        let alertController = UIAlertController(title: "Tem certeza que deseja sair?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let actionSair = UIAlertAction(title: "Sair",
                                       style: .destructive) { (alertAction) in
                                        self.fazerLogOut()
        }
        
        let actionCancelar = UIAlertAction(title: "Cancelar",
                                           style: .cancel, handler: nil)
        
        
        alertController.addAction(actionSair)
        alertController.addAction(actionCancelar)
        
        
        let indexPathCelulaSair = IndexPath(row: 0, section: 3)
        tableView.deselectRow(at: indexPathCelulaSair, animated: true)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func fazerLogOut()  {
        
        let itensDeletados = manager.deletar()
        
        if itensDeletados {
            let facebookLoginManager = FBSDKLoginManager()
            facebookLoginManager.logOut()
            
            let controllerLogin: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AppDelegate.shared.loginControllerIdentifier) as! LoginViewController
            self.present(controllerLogin, animated: true, completion: nil)
        }
        else {
            
            let alertController = UIAlertController(title: "Problema ao Sair",
                                                    message: "Não foi possível sair, tente novamente.",
                                                    preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
