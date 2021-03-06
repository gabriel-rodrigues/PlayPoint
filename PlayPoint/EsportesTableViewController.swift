//
//  EsportesTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import SwiftSpinner

class EsportesTableViewController: UITableViewController {

    
    @IBOutlet weak var salvarButtonItem: UIBarButtonItem!
    @IBOutlet weak var prontoButtonItem: UIBarButtonItem!
    
    
    private let esporteManager    = EsporteDataManager()
    private var esportes          = [EsporteMO]()
    private var esportesFiltrados = [EsporteMO]()
    private let searchController  = UISearchController(searchResultsController: nil)
    private let urlServer         = "https://playpoint.azurewebsites.net/api/esportes"
    
    public var isParaFavorito: Bool!
    public var usuario: UsuarioMO!
    public var isSelecaoMultipla = true
    public var selecionaEsporteDelegate: SelecionaEsporteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.configurarButtonsCorretamente()
        self.configurarSearchController()
        self.configurarParaPrimeiraVez()
    }

    func buscarEsportesServidor() {
        
        
        var request        = URLRequest(url: URL(string: urlServer)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (esportes, response, error) in
            
            guard let esportes = esportes, error == nil else {
                self.showMessageErrorBuscarEsportes()
                return
            }
            
            let esportesJSON  = JSON(data: esportes)
            var esportesItens = [EsporteItem]()
            
            for esporteJSON in esportesJSON {
                let esporteItem = EsporteItem(json: esporteJSON.1)
                esportesItens.append(esporteItem)
            }
            
            if(!esportesItens.isEmpty) {
                
                SwiftSpinner.hide({
                    self.esporteManager.seed(esportes: esportesItens)
                    self.filtarEsportesFavoritosOrInteressados()
                    self.tableView.reloadData()
                })
                
            }
        }
        
        task.resume();
        SwiftSpinner.show("Buscando os esportes...")
    }
    
    func showMessageErrorBuscarEsportes()
    {
        
        SwiftSpinner.hide {
            let alert = UIAlertController(title: "Oops",
                                          message: "Não foi possível buscar todos os esportes. Tente novamente.",
                                          preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alert.addAction(actionOK)
            
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func configurarButtonsCorretamente() {
        
        if !isSelecaoMultipla {
            salvarButtonItem.isEnabled = false
            salvarButtonItem.tintColor = UIColor.clear
        }
        
    }
    
    
    func configurarParaPrimeiraVez() {
        
        if(!esporteManager.esportesInseridos()) {
            self.buscarEsportesServidor()
        }
        else {
            self.filtarEsportesFavoritosOrInteressados()
        }
    }
    
    
    func filtarEsportesFavoritosOrInteressados() {
        
        let esportes = esporteManager.recuperarTodos()
        
    
        if isSelecaoMultipla {
            let esportesFiltrados = esportes.filter { (esporte) -> Bool in
                
                let esportesUsuarios     = self.usuario.esportesUsuarios?.allObjects as! [UsuarioEsporteMO]
                let contain: [UsuarioEsporteMO]
                
                if self.isParaFavorito {
                    
                    contain = esportesUsuarios.filter({ (usuarioEsporte) -> Bool in
                        return usuarioEsporte.esporte == esporte && !usuarioEsporte.isFavorito
                    })
                }
                else {
                    
                    contain = esportesUsuarios.filter({ (usuarioEsporte) -> Bool in
                        return usuarioEsporte.esporte == esporte && usuarioEsporte.isFavorito
                    })
                }
                
                return contain.count == 0
            }
            
            
            self.esportes = esportesFiltrados
        }
        else {
            self.esportes = esportes
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configurarSearchController() {
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater             = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar por esportes"
        self.searchController.searchBar.setValue("Cancelar", forKey:"_cancelButtonText")
        self.searchController.searchBar.searchBarStyle = .minimal
        self.definesPresentationContext = true
        self.tableView.tableHeaderView  = searchController.searchBar
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive && !searchController.searchBar.text!.isEmpty {
            return self.esportesFiltrados.count
        }
        
        return self.esportes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell     = tableView.dequeueReusableCell(withIdentifier: "celulaEsporte", for: indexPath)
        let esportes = self.searchController.isActive && !searchController.searchBar.text!.isEmpty ? self.esportesFiltrados : self.esportes
        let esporte  = esportes[indexPath.row]

       
        cell.textLabel?.text = esporte.descricao
        
        if isSelecaoMultipla {
            let filtrados = self.usuario.esportesUsuarios!.filter({ (item) -> Bool in
                let usuarioEsporte = item as! UsuarioEsporteMO
                
                return usuarioEsporte.esporte == esporte && usuarioEsporte.isFavorito == isParaFavorito
            })
            
            cell.accessoryType = filtrados.count == 1 ? .checkmark : .none
        }
        else {
            if let esporteSelecionado = selecionaEsporteDelegate?.esporteSelecionado {
                if esporte == esporteSelecionado {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell     = tableView.cellForRow(at: indexPath)!
        let esportes = self.searchController.isActive && !searchController.searchBar.text!.isEmpty ? self.esportesFiltrados : self.esportes
        let esporte  = esportes[indexPath.row]
        
        
        if isSelecaoMultipla {
            if let indice = self.obterIndiceParaFavoritoOrInteressado(esporte: esporte) {
                
                cell.accessoryType = .none
                let usuarioEsporte = self.usuario.esportesUsuarios?.allObjects[indice] as! UsuarioEsporteMO
                self.usuario.removeFromEsportesUsuarios(usuarioEsporte)
            }
            else {
                cell.accessoryType = .checkmark
                
                let usuarioEsporteMO        = UsuarioEsporteMO(context: DataManager.shared.context)
                usuarioEsporteMO.isFavorito = self.isParaFavorito
                usuarioEsporteMO.esporte    = esporte
                
                self.usuario.addToEsportesUsuarios(usuarioEsporteMO)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
        else {
            self.navigationController?.popViewController(animated: true)
            self.selecionaEsporteDelegate?.selecionar(esporte: esporte)
        }
        
    }
    
    
    func obterIndiceParaFavoritoOrInteressado(esporte: EsporteMO) -> Array<UsuarioEsporteMO>.Index? {
        
        let esportesUsuarios     = self.usuario.esportesUsuarios!.allObjects as! [UsuarioEsporteMO]
        
        let indiceEsporteUsuario = esportesUsuarios.index { (usuarioEsporte) -> Bool in
            return usuarioEsporte.esporte == esporte && usuarioEsporte.isFavorito == isParaFavorito
        }
        
        return indiceEsporteUsuario
    }
    
    func filtrarEsportes(por termo: String) {
        
        self.esportesFiltrados = self.esportes.filter({ (esporte) -> Bool in
            return esporte.descricao!.lowercased().contains(termo.lowercased())
        })
        
        
        self.tableView.reloadData()
    }
}

extension EsportesTableViewController : UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.barTintColor   = AppDelegate.shared.laranjaApp
        searchController.searchBar.tintColor      = UIColor.white
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.searchBarStyle = .minimal
    }
}

extension EsportesTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filtrarEsportes(por: searchController.searchBar.text!)
    }
}
