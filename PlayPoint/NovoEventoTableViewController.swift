//
//  NovoEventoTableViewController.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 03/05/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit

class NovoEventoTableViewController: UITableViewController {

    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nomeEventoTextField: UITextField!
    @IBOutlet weak var esporteTextField: UITextField!
    @IBOutlet weak var localTextField: UITextField!
    @IBOutlet weak var dataHoraTextField: UITextField!
    @IBOutlet weak var dataHoraDatePicker: UIDatePicker!
    
    private let heightCelulaFoto   = 250
    private let heightCelulaCampos = 72
    private let heightCelulaPicker = 216
    private let heightCelulaHidden = 0.0

    
    fileprivate var _esporteSelecionado: EsporteMO?
    var local: LocalItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.row) {
        case 0:
            return CGFloat(heightCelulaFoto)
        case 1, 2, 3, 4:
            return CGFloat(heightCelulaCampos)
        case 5:
            return self.dataHoraDatePicker.isHidden ? CGFloat(heightCelulaHidden): CGFloat(heightCelulaPicker)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        switch indexPath.row {
        case 0:
            self.selecionarFoto()
        case 4:
           self.togglePicker(picker: self.dataHoraDatePicker, in: indexPath)
        default: break
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let identifier = segue.identifier {
            if identifier == Segue.showEscolhaEsporte.rawValue {
                let controller = segue.destination as! EsportesTableViewController
                controller.navigationItem.title     = "Esportes"
                controller.isSelecaoMultipla        = false
                controller.selecionaEsporteDelegate = self
                
            }
        }
    }
 
    func selecionarFoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType    = .photoLibrary
            imagePicker.delegate      = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    func aplicarConstraintsParaExibirTamanhoImagemCorretamente() {
        
        let leadingConstraint = NSLayoutConstraint(item: fotoImageView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: fotoImageView.superview,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 0)
        
        leadingConstraint.isActive = true
        
        
        let trailingContraint = NSLayoutConstraint(item: fotoImageView,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: fotoImageView.superview,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: 0)
        
        trailingContraint.isActive = true
        
        let topContraint = NSLayoutConstraint(item: fotoImageView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: fotoImageView.superview,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0)
        
        topContraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: fotoImageView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: fotoImageView.superview,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        
        bottomConstraint.isActive = true

    }
    
    
    @IBAction func salvarEvento(_ sender: UIBarButtonItem) {
        
        
        let fotoIsNotSelected   = self.fotoImageView.image == nil
        let nomeIsEmpty      = self.nomeEventoTextField.text!.isEmpty
        let esporteIsEmpty   = self.esporteTextField.text!.isEmpty
        let localIsEmpty     = self.localTextField.text!.isEmpty
        let dataHorasIsEmpty = self.dataHoraTextField.text!.isEmpty
        
        
        if fotoIsNotSelected || nomeIsEmpty || esporteIsEmpty || localIsEmpty || dataHorasIsEmpty {
            let alertController = UIAlertController(title: "Oops!",
                                                    message: "É necessário preencher todos os campos e escolher a imagem para criar o evento de maneira correta.",
                                                    preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(actionOk)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.criarEvento()
        }
    }
    
    private func criarEvento()  {
        
        let usuario             = UsuarioDataManager().recuperarUnicoUsuario()!
        let evento              = EventoMO(context: DataManager.shared.context)
        evento.nome             = self.nomeEventoTextField.text
        evento.dataCriacao      = Date() as NSDate
        evento.dataInicio       = self.dataHoraDatePicker.date as NSDate
        evento.imagem           = UIImagePNGRepresentation(self.fotoImageView.image!)! as NSData
        evento.esporte          = self.esporteSelecionado
        evento.local            = LocalMO(context: DataManager.shared.context)
        evento.local!.nome      = self.local.nome
        evento.local!.latitude  = self.local.latitude
        evento.local!.longitude = self.local.longitude
        evento.addToUsuarios(usuario)
        
        DataManager.shared.save()
        
        self.performSegue(withIdentifier: Segue.unwindCancelarNovoEvento.rawValue, sender: nil)
    }
    
    @IBAction func changeDataHora(_ sender: UIDatePicker) {
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        self.dataHoraTextField.text = dataFormatter.string(from: sender.date)
    }
    
    @IBAction func unwindEsportePronto(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindLocalPronto(segue: UIStoryboardSegue) {
        
        if let controller = segue.source as? LocalViewController {
            self.local               = controller.local
            self.localTextField.text = controller.local.nome
        }
    }
    
}

extension NovoEventoTableViewController : SelecionaEsporteDelegate {
    
    var esporteSelecionado: EsporteMO?  {
        get {
            return self._esporteSelecionado
        }
        set (esporte) {
            self._esporteSelecionado = esporte
        }
    }

    
    func selecionar(esporte: EsporteMO) {
        
        esporteSelecionado = esporte
        
        self.esporteTextField.text = self.esporteSelecionado?.descricao
    }

}

extension NovoEventoTableViewController : UINavigationControllerDelegate {
    
}

extension NovoEventoTableViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagemSelecionada = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.fotoImageView.image         = imagemSelecionada
            self.fotoImageView.contentMode   = .scaleAspectFill
            self.fotoImageView.clipsToBounds = true
            
            self.aplicarConstraintsParaExibirTamanhoImagemCorretamente()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension NovoEventoTableViewController: TogglePickerCustomProtocol {
    
}
