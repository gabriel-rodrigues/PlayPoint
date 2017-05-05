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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
