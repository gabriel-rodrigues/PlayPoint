//
//  EventosViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 03/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import CoreData

class EventosViewController: UIViewController {

    public let cellIdentifier = "celulaEvento"
    
    @IBOutlet weak var tableView: UITableView!
   
    fileprivate var fetchResultController: NSFetchedResultsController<EventoMO>!
    fileprivate var eventos: [EventoMO] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.recuperarDados()
        self.configurarEmptyDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recuperarDados() {
        
        
        let fetchRequest    = NSFetchRequest<EventoMO>(entityName: "Evento")
        let fetchDescriptor = NSSortDescriptor(key: "dataCriacao", ascending: false)
        fetchRequest.sortDescriptors = [fetchDescriptor]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: DataManager.shared.context,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        fetchResultController.delegate = self
        if let _ = try? fetchResultController.performFetch() {
            if let objetosRecuperados = fetchResultController.fetchedObjects {
                eventos = objetosRecuperados
            }
        }
    }
    
    
    func configurarEmptyDataSource() {
        
        self.tableView.emptyDataSetSource = self
        //self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    

    @IBAction func unwindCancelarNovoEvento(segue: UIStoryboardSegue) {
        
    }

}

extension EventosViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        
        if let objetosRecuperados = controller.fetchedObjects {
            eventos = objetosRecuperados as! [EventoMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
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
        
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let evento = eventos[indexPath.row]
        let celula = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! EventoTableViewCell
        
        celula.nomeEnvetoLabel.text = evento.nome
        celula.localLabel.text      = evento.local!.nome
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        celula.dataHoraLabel.text = dataFormatter.string(from: evento.dataInicio! as Date)
        celula.fotoImavem.image   = UIImage(data: evento.imagem! as Data)
        celula.fotoImavem.layer.cornerRadius = celula.fotoImavem.frame.size.width / 2
        celula.fotoImavem.clipsToBounds      = true
        
        return celula
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "novo_evento")
    }
}

extension EventosViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionCancelar = UITableViewRowAction(style: .destructive,
                                                  title: "Cancelar") { (action, indexPath) in
                                                    
            let alertController = UIAlertController(title: nil,
                                                message: "Você deseja realmente cancelar este evento?",
                                                preferredStyle: .actionSheet)
                                                    
            let actionOk = UIAlertAction(title: "Sim",
                                         style: .destructive,
                                         handler:  { (action) in
                                            
                let evento = self.fetchResultController.object(at: indexPath)
                DataManager.shared.context.delete(evento)
                DataManager.shared.save()
            })
            
            let actionCancelar = UIAlertAction(title: "Não",
                                               style: .cancel,
                                               handler: nil)
                                                    
            alertController.addAction(actionOk)
            alertController.addAction(actionCancelar)
                                                    
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        return [actionCancelar]
    }
}


extension EventosViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
