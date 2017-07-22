//
//  EventosViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 03/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit

class EventosViewController: UIViewController {

    public let cellIdentifier = "celulaEvento"
    
    @IBOutlet weak var tableView: UITableView!
   
    internal let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurarSearchController()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventosViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! EventoTableViewCell
        
        celula.nomeEnvetoLabel.text = "Skate Sinistro"
        
        return celula
    }
}


extension EventosViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
