//
//  EventosViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 03/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EventosViewController: UIViewController {

    public let cellIdentifier = "celulaEvento"
    
    @IBOutlet weak var tableView: UITableView!
   
    internal let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.configurarSearchController()
        self.configurarEmptyDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configurarSearchController() {
        
        self.searchController.searchResultsUpdater             = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder            = "Buscar"
        self.searchController.searchBar.setValue("Cancelar", forKey: "_cancelButtonText")
        self.tableView.tableHeaderView                         = searchController.searchBar
        
    }
    
    
    func configurarEmptyDataSource() {
        
        self.tableView.emptyDataSetSource = self
        //self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    

    @IBAction func unwindCancelarNovoEvento(segue: UIStoryboardSegue) {
        
    }

}

extension EventosViewController : DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let mensagem = "Novos eventos"
        return NSAttributedString(string: mensagem)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let mensagem = "Nenhum evento cadastrado até o momento."
        let attrs    = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: mensagem, attributes: attrs)
    }
}


extension EventosViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! EventoTableViewCell
        
        celula.nomeEnvetoLabel.text = "Skate Sinistro"
        
        return celula
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "novo_evento")
    }
}


extension EventosViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
