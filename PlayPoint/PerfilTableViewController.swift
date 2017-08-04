//
//  PerfilTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 04/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData

class PerfilTableViewController: UITableViewController {

    
    
    @IBOutlet weak var fotoImagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var usuarioDesdeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var quantidadeFavoritosLabel: UILabel!
    @IBOutlet weak var quantidadeInteressadosLabel: UILabel!
    @IBOutlet weak var quantidadeEventosMeusLabel: UILabel!
    @IBOutlet weak var quantidadeEventosConfirmadosLabel: UILabel!
    
    
    private let manager = UsuarioDataManager()
    private var usuario: UsuarioMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usuario = manager.recuperarUnicoUsuario()!
        
        self.fotoImagemView.image = UIImage(data: self.usuario.foto! as Data)
        self.fotoImagemView.layer.cornerRadius = fotoImagemView.frame.size.width / 2
        self.fotoImagemView.clipsToBounds = true
        self.nomeLabel.text       = self.usuario.nomeCompleto
        self.emailLabel.text      = self.usuario.email
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        self.usuarioDesdeLabel.text = dataFormatter.string(from: usuario.dataCadastro! as Date)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.beginUpdates()
        self.configurarLabelsQuantidadeEventos()
        tableView.endUpdates()
    }
    
    func configurarLabelsQuantidadesParaEsportes() {
        
        
        let quantidadeFavoritos    = recuperarQuantidade(isFavorito: true)
        let quantidadeInteressados = recuperarQuantidade(isFavorito: false)
        
        self.quantidadeFavoritosLabel.text    = (quantidadeFavoritos > 0) ? "\(quantidadeFavoritos)" : ""
        self.quantidadeInteressadosLabel.text = (quantidadeInteressados > 0) ? "\(quantidadeInteressados)" : ""
        
    }
    
    
    func configurarLabelsQuantidadeEventos() {
        
        let quantidadeEventosCriados      = recuperarQuantidadeEventosMeus()
        let quantidadesEventosConfirmados = recuperarQuantidadeEventosConfirmados()
        
        self.quantidadeEventosMeusLabel.text        = (quantidadeEventosCriados > 0) ? "\(quantidadeEventosCriados)" : ""
        self.quantidadeEventosConfirmadosLabel.text = (quantidadesEventosConfirmados > 0) ? "\(quantidadesEventosConfirmados)" : ""
    }

    func recuperarQuantidade(isFavorito: Bool) -> Int {
        
        let itensFiltrados     = self.usuario.esportesUsuarios?.filter({ (item) -> Bool in
            let usuarioEsporte = item as! UsuarioEsporteMO
            
            return usuarioEsporte.isFavorito == isFavorito
        })
        
        guard let itens = itensFiltrados else {
            return 0
        }
        
        return itens.count
    }
    
    func recuperarQuantidadeEventosMeus() -> Int {
        
        let itensFiltrados = self.usuario.participantes?.filter({ (participante) -> Bool in
            let usuarioParticipante = participante as! ParticipanteMO
            
            return usuarioParticipante.isCriador
        })
        
        guard let itens = itensFiltrados else {
            return 0
        }
        
        return itens.count
    }
    
    func recuperarQuantidadeEventosConfirmados() -> Int {
        
        let itensFiltrados = self.usuario.participantes?.filter({ (participante) -> Bool in
            let usuarioParticipante = participante as! ParticipanteMO
            
            return usuarioParticipante.dataConfirmacao != nil && usuarioParticipante.dataCancelamento == nil
        })
        
        guard let itens = itensFiltrados else {
            return 0
        }
        
        return itens.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 && indexPath.row == 0 {
            self.confirmaLogOut(celulaSair: indexPath)
        }
    }
    
    func confirmaLogOut(celulaSair indexPath: IndexPath)  {
        
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
        

        self.tableView.deselectRow(at: indexPath, animated: true)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func fazerLogOut()  {
        
        let itensDeletados =  manager.deletar()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            var isFavorito = false
            
            if identifier == Segue.showEsportesFavoritos.rawValue {
                segue.destination.navigationItem.title = "Favoritos"
                isFavorito = true
            }
            else {
                segue.destination.navigationItem.title = "Interessados"
            }
            
            let controller            = segue.destination as! EsportesTableViewController
            controller.usuario        = self.usuario
            controller.isParaFavorito = isFavorito
        }
    }
    
    
    @IBAction func unwindSalvarEsportes(segue: UIStoryboardSegue) {
    
        DataManager.shared.save()
        self.configurarLabelsQuantidadesParaEsportes()
    }

}


