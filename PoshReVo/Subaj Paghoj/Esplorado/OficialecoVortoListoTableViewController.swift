//
//  OficialecoVortoListoTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/10/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import ReVoDatumbazo

final class OficialecoVortoListoTableViewController: BazStilaTableViewController {
    
    private let chelIdentigilo = "oficialecoVortoChelo"
    
    private let oficialeco: Oficialeco
    private let vortoj: [Destino]
    
    init(_ oficialeco: Oficialeco) {
        self.oficialeco = oficialeco
        vortoj = VortaroDatumbazo.komuna.ofcVortoj(porOficialeco: oficialeco.kodo)
        super.init(style: .plain)
        
        title = Iloj.majuskligiUnuan(oficialeco.nomo)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Ne kreu OficialecoVortoListoTableViewController tiel")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension OficialecoVortoListoTableViewController {

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
        let destino = vortoj[indexPath.row]
        
        chelo.textLabel?.text = destino.teksto
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vortoDestino = vortoj[indexPath.row]
        guard let artikolo = VortaroDatumbazo.komuna.artikolo(de: vortoDestino) else {
            return
        }
        
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: oficialeco.nomo, style: .plain, target: nil, action: nil)
        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
    }
}
