//
//  FakojTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/21/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import ReVoDatumbazo

import UIKit

final class FakoListoTableViewController: BazStilaTableViewController {
    
    private static let chelIdent = "FakojChelIdent"
    
    private let fakoj = VortaroDatumbazo.komuna.chiujFakoj
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("esplori fakoj titolo", comment: "")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakoj.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo = tableView.dequeueReusableCell(withIdentifier: FakoListoTableViewController.chelIdent) ?? UITableViewCell(style: .value1, reuseIdentifier: FakoListoTableViewController.chelIdent)
        
        let fako = fakoj[indexPath.row]
        
        novaChelo.textLabel?.text = fako.nomo
        novaChelo.detailTextLabel?.text = fako.kodo
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return novaChelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fako = fakoj[indexPath.row]
        let listoVC = FakVortoListoTableViewController(fako)
        navigationController?.pushViewController(listoVC, animated: true)
    }
    
}
