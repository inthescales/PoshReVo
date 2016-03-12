//
//  HistorioViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let historiChelIdent = "historioChelo"

class HistorioViewController : UIViewController {

    @IBOutlet var vortoTabelo: UITableView?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("historio titolo", comment: "")
           
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: historiChelIdent)
        vortoTabelo?.reloadData()
    }
    
}

extension HistorioViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UzantDatumaro.historio.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = vortoTabelo?.dequeueReusableCellWithIdentifier(historiChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.textLabel?.text = UzantDatumaro.historio[indexPath.row].nomo
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indekso = UzantDatumaro.historio[indexPath.row].indekso
        if let artikolo = SeancDatumaro.artikoloPorIndekso(indekso) {
            (navigationController as? ChefaNavigationController)?.montriArtikolon( artikolo )
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
