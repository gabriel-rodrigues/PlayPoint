//
//  EsportesTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import CoreData

class EsportesTableViewController: UITableViewController {

    private let esporteManager    = EsporteDataManager()
    private var esportes          = [EsporteMO]()
    private var esportesFiltrados = [EsporteMO]()
    private let searchController  = UISearchController(searchResultsController: nil)
    
    public var isParaFavorito: Bool!
    public var usuario: UsuarioMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.configurarSearchController()
        self.filtarEsportesFavoritosOrInteressados()
    }
    
    
    func filtarEsportesFavoritosOrInteressados() {
        
        let esportes = esporteManager.recuperarTodos()
        
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configurarSearchController() {
        
        self.searchController.searchResultsUpdater             = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setValue("Cancelar", forKey:"_cancelButtonText")
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
        let filtrados = self.usuario.esportesUsuarios!.filter({ (item) -> Bool in
            let usuarioEsporte = item as! UsuarioEsporteMO
            
            return usuarioEsporte.esporte == esporte && usuarioEsporte.isFavorito == isParaFavorito
        })
        
        cell.accessoryType = filtrados.count == 1 ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell     = tableView.cellForRow(at: indexPath)!
        let esportes = self.searchController.isActive && !searchController.searchBar.text!.isEmpty ? self.esportesFiltrados : self.esportes
        let esporte  = esportes[indexPath.row]
        
        
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



extension EsportesTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filtrarEsportes(por: searchController.searchBar.text!)
    }
}
