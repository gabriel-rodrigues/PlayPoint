//
//  EsportesTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 27/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit

class EsportesTableViewController: UITableViewController {

    private let esporteManager = EsporteDataManager()
    private var esportes       = [EsporteItem]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    public var usuario: UsuarioMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.configurarSearchController()
        self.esportes = esporteManager.recuperarTodos()
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
        
        return self.esportes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaEsporte", for: indexPath)

        let esporte = self.esportes[indexPath.row]

       
       cell.textLabel?.text = esporte.descricao
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .checkmark
        }
    }
 
    @IBAction func salvarEsportes(_ sender: UIBarButtonItem) {
        
        
    }
}

extension EsportesTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
