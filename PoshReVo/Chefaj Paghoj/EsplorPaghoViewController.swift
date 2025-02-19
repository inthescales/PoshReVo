//
//  EsplorPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/21/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import UIKit

import ReVoDatumbazo

private enum Chelo: Int {
    case Oficialeco, Fakoj, IuAjn
    
    public static let kvanto = [2, 1]
    
    init?(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.init(rawValue: indexPath.row)
        case 1:
            self.init(rawValue: Chelo.kvanto[0] + indexPath.row)
        default:
            self.init(rawValue: 0)
        }
    }
    
    func titolo() -> String {
        switch self {
        case .Oficialeco:
            return NSLocalizedString("esplori oficialeco titolo", comment: "")
        case .Fakoj:
            return NSLocalizedString("esplori fakoj titolo", comment: "")
        case .IuAjn:
            return NSLocalizedString("esplori iu ajn titolo", comment: "")
        }
    }
}

final class EsplorPaghoViewController: BazStilaTableViewController, Chefpagho {

    private static let chelIdent = "EsplorPaghoChelIdent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        parent?.title = NSLocalizedString("esplori titolo", comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chelo.kvanto[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let novaChelo = tableView.dequeueReusableCell(withIdentifier: EsplorPaghoViewController.chelIdent) ?? UITableViewCell()
        let chelTipo = Chelo(indexPath: indexPath)
        
        novaChelo.textLabel?.text = chelTipo?.titolo()
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro

        return novaChelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let chelTipo = Chelo(indexPath: indexPath) else {
            return
        }
        
        switch chelTipo {
        case .Oficialeco:
            let oficialecoVC = OficialecoListoTableViewController(style: .plain)
            navigationController?.pushViewController(oficialecoVC, animated: true)
        case .Fakoj:
            let fakojVC = FakoListoTableViewController(style: .plain)
            navigationController?.pushViewController(fakojVC, animated: true)
        case .IuAjn:
            if let artikolo = VortaroDatumbazo.komuna.iuAjnArtikolo(),
                let navigaciilo = navigationController as? ChefaNavigationController {
                navigaciilo.montriArtikolon(artikolo)
            }
        }
    }
}
