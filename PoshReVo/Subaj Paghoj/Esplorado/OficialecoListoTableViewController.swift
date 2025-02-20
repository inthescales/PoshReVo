//
//  OficialecoListoTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/10/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import ReVoDatumbazo

import UIKit

final class OficialecoListoTableViewController: BazStilaTableViewController {
    
    private static let chelIdent = "OficialecoChelIdent"
    
    private let oficialecoj = VortaroDatumbazo.komuna.chiujOficialecoj ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("esplori oficialeco titolo", comment: "")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oficialecoj.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo = tableView.dequeueReusableCell(withIdentifier: OficialecoListoTableViewController.chelIdent) ?? UITableViewCell(style: .value1, reuseIdentifier: OficialecoListoTableViewController.chelIdent)
        
        let oficialeco = oficialecoj[indexPath.row]
        
        novaChelo.textLabel?.text = oficialeco.nomo.prefix(1).uppercased() + oficialeco.nomo.dropFirst()
        novaChelo.detailTextLabel?.text = oficialeco.indikilo
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return novaChelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oficialeco = oficialecoj[indexPath.row]
        let listoVC = OficialecoVortoListoTableViewController(oficialeco)
        navigationController?.pushViewController(listoVC, animated: true)
    }
    
}
