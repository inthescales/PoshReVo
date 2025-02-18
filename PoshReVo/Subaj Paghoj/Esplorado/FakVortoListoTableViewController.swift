//
//  FakVortoListoTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 9/1/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation

import ReVoModeloj
import ReVoDatumbazo

final class FakVortoListoTableViewController: BazStilaTableViewController {
    
    private let chelIdentigilo = "fakVortoChelo"
    
    private let fako: Fako
    private let vortoj: [Destino]
    
    init(_ fako: Fako) {
        self.fako = fako
        vortoj = VortaroDatumbazo.komuna.fakVortoj(porFako: fako.kodo)
        super.init(style: .plain)
        
        title = Iloj.majuskligiUnuan(fako.nomo)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Ne kreu FakVortoListoTableViewController tiel")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FakVortoListoTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: chelIdentigilo)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vortoj.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chelo = tableView.dequeueReusableCell(withIdentifier: chelIdentigilo) ?? UITableViewCell()
        let vortoDestino = vortoj[indexPath.row]
        
		chelo.textLabel?.text = vortoDestino.teksto
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vortoDestino = vortoj[indexPath.row]
        guard let artikolo = VortaroDatumbazo.komuna.artikolo(de: vortoDestino) else {
            return
        }
        
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: fako.nomo, style: .plain, target: nil, action: nil)
        if let marko = vortoDestino.marko, !marko.isEmpty {
            (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
        } else {
            (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
        }
    }
}
