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

    
    @IBOutlet weak var salvarButtonItem: UIBarButtonItem!
    @IBOutlet weak var prontoButtonItem: UIBarButtonItem!
    
    
    private let esporteManager    = EsporteDataManager()
    private var esportes          = [EsporteMO]()
    private var esportesFiltrados = [EsporteMO]()
    private let searchController  = UISearchController(searchResultsController: nil)
    
    public var isParaFavorito: Bool!
    public var usuario: UsuarioMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.configurarButtonsCorretamente()
        self.configurarSearchController()
        self.filtarEsportesFavoritosOrInteressados()
    }
    
    
    func configurarButtonsCorretamente() {
        
        guard let _ = isParaFavorito else {
            salvarButtonItem.isEnabled = false
            salvarButtonItem.tintColor = UIColor.clear
            
            return
        }
        
    }
    
    func filtarEsportesFavoritosOrInteressados() {
        
        let esportes = esporteManager.recuperarTodos()
        
    
        /*let esportesFiltrados = esportes.filter { (esporte) -> Bool in
            
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
        
        
        self.esportes = esportesFiltrados*/
        self.esportes = esportes
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
        /*let filtrados = self.usuario.esportesUsuarios!.filter({ (item) -> Bool in
            let usuarioEsporte = item as! UsuarioEsporteMO
            
            return usuarioEsporte.esporte == esporte && usuarioEsporte.isFavorito == isParaFavorito
        })
        
        cell.accessoryType = filtrados.count == 1 ? .checkmark : .none*/
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell     = tableView.cellForRow(at: indexPath)!
        let esportes = self.searchController.isActive && !searchController.searchBar.text!.isEmpty ? self.esportesFiltrados : self.esportes
        let esporte  = esportes[indexPath.row]
        
        
        /*if let indice = self.obterIndiceParaFavoritoOrInteressado(esporte: esporte) {
            
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
        }*/
    
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
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
