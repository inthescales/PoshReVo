//
//  VortoDisigiloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/31/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

import ReVoModeloj
import ReVoDatumbazo

let disigiloChelIdent = "vortoDisigiloChelo"

class VortoDisigiloTableViewCell : UITableViewCell {
    
}

class VortoDisigiloViewController : UIViewController, Stilplena {

    var destinoj = [Destino]()
    @IBOutlet var vortoTabelo: UITableView?
    
    init(endestinoj: [Destino]) {
        destinoj = endestinoj
        super.init(nibName: "VortoDisigiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = (destinoj.first?.teksto) ?? "disigilo"
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.register(VortoDisigiloTableViewCell.self, forCellReuseIdentifier: disigiloChelIdent)
        efektivigiStilon()
    }
    
    func efektivigiStilon() {

        vortoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        vortoTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        vortoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        vortoTabelo?.reloadData()
    }
    
    func devasMontriSencon(indexPath: IndexPath) -> Bool {
        
        if (destinoj[indexPath.row].senco) == "0" {
            return false
        }
        
        return true
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension VortoDisigiloViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return destinoj.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let chelo = UITableViewCell(style: .value1, reuseIdentifier: disigiloChelIdent)
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        chelo.textLabel?.text = destinoj[indexPath.row].teksto
        chelo.detailTextLabel?.text = destinoj[indexPath.row].subteksto
        if devasMontriSencon(indexPath: indexPath),
            let senco = destinoj[indexPath.row].senco {
            chelo.detailTextLabel?.text = (chelo.detailTextLabel?.text ?? "") + Iloj.superLit(senco)
        }
        
        return chelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destino = destinoj[indexPath.row]
		guard let artikolo = VortaroDatumbazo.komuna.artikolo(de: destino) else {
            return
        }
        
        if let marko = destino.marko, !marko.isEmpty {
            (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
        } else {
            (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
