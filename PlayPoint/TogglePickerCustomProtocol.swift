//
//  TogglePickerCustomProtocol.swift
//  PlayPoint
//
//  Created by Gabriel Rodrigues on 30/07/17.
//  Copyright © 2017 Iesb. All rights reserved.
//

import UIKit

protocol TogglePickerCustomProtocol {
    
    var tableView: UITableView! { get }
}

extension TogglePickerCustomProtocol {
    
    func togglePicker(picker view: UIView , in indexPath: IndexPath) {
        
        view.isHidden = !view.isHidden
        
        UIView.animate(withDuration: 0.3) { 
            self.tableView.beginUpdates()
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.endUpdates()
            
            if !view.isHidden {
                let indexPathPicker = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                self.tableView.scrollToRow(at: indexPathPicker, at: .none, animated: true)
            }
        }
    }
    
}
