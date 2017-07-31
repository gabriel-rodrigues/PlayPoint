//
//  LocalViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 30/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class LocalViewController: UIViewController {

    @IBOutlet weak var termoPesquisaTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var local: LocalItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.termoPesquisaTextField.becomeFirstResponder()
        
        let touchGesto = UITapGestureRecognizer(target: self, action: #selector(removerFocusCampoTermoPesquisa))
        self.mapView.addGestureRecognizer(touchGesto)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pesquisar(_ sender: UIBarButtonItem) {
        
        let termoIsEmpty = self.termoPesquisaTextField.text!.isEmpty
        
        if termoIsEmpty {
            
            let alertController = UIAlertController(title: "Oops",
                                                    message: "É necessário um termo de pesquisa para encontrar o local",
                                                    preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(actionOK)
            
            self.present(alertController,
                         animated: true,
                         completion: nil)
        }
        else {
            
            SwiftSpinner.show("Pesquisando pelo local...", animated: true)
            self.removerFocusCampoTermoPesquisa()
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(self.termoPesquisaTextField.text!, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    self.showMensagemErroAoBuscarEndereco()
                }
                
                if let placemarks = placemarks {
                    
                    let placemark    = placemarks[0]
                    let annotation   = MKPointAnnotation()
                    
                    
                    
                    if let location = placemark.location {
                        self.local            = LocalItem(markplace: placemark)
                        annotation.coordinate = location.coordinate
                        
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)
                        
                        SwiftSpinner.hide()
                    }
                }
                
            })
        }
        
    }
    
    func removerFocusCampoTermoPesquisa() {
        
        self.termoPesquisaTextField.resignFirstResponder()
        
    }
    
    func showMensagemErroAoBuscarEndereco() {
        
        SwiftSpinner.hide()
        
        let alertController = UIAlertController(title: "Oops",
                                                message: "Não foi possível localizar nenhum local com esse nome, troque e tente novamente.",
                                                preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(actionOK)
        
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    func showMensagemPesquiseEndereco() {
        
        let alertController = UIAlertController(title: "Oops",
                                                message: "É necessário pesquisar por um endereço antes.",
                                                preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(actionOK)
        
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let _ = self.local {
            return true
        }
        
        
        self.showMensagemPesquiseEndereco()
        return false
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
