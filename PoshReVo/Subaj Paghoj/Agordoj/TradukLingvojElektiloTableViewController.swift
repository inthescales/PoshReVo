//
//  TradukLingvojElektiloTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

import ReVoDatumbazo

let tradukLingvojElektiloChelIdent = "tradukLingvoElektiloChelo"

/*
    Pagho por elekti lingvojn en kiu tradukoj por vortoj montrighos.
*/
class TradukLingvojElektiloTableViewController : BazStilaTableViewController {
    
    var shanghisLingvojn: Bool = false
    
    var tradukLingvoj = [Lingvo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("traduk-elektilo titolo", comment: "")
        tradukLingvoj = kaptiTradukLingvojn()
        
        let redaktButono = UIBarButtonItem.init(title: NSLocalizedString("traduk-elektilo redakti", comment: ""),
                                                style: .plain,
                                                target: self,
                                                action: #selector(TradukLingvojElektiloTableViewController.premisRedakti(sender:)))
        navigationItem.rightBarButtonItem = redaktButono
        ghisdatigiButonon()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tradukLingvojElektiloChelIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if shanghisLingvojn {
            NotificationCenter.default.post(name: NSNotification.Name(AtentigoNomoj.elektisTradukLingvojn), object: nil)
        }
    }
    
    private func kaptiTradukLingvojn() -> [Lingvo] {
        return Array<Lingvo>(UzantDatumaro.tradukLingvoj).sorted { (unua: Lingvo, dua: Lingvo) -> Bool in
            return unua.nomo.compare(dua.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        }
    }
    
    // MARK: - UI agordadon
    
    private func ghisdatigiButonon() {
        navigationItem.rightBarButtonItem?.isEnabled = (tableView.isEditing || tradukLingvoj.count > 0)
        
        if !tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("traduk-elektilo redakti", comment: "")
        } else {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("traduk-elektilo fini", comment: "")
        }
        
    }
    
    private func ghisdatigiRedaktadon() {
        ghisdatigiButonon()
        
        if tableView.isEditing {
            tableView.beginUpdates()
            tableView.deleteSections([tableView.numberOfSections - 1], with: .fade)
            tableView.endUpdates()
        } else {
            tableView.beginUpdates()
            tableView.insertSections([tableView.numberOfSections], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: UI agoj
    
    @objc func premisRedakti(sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        ghisdatigiRedaktadon()
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        let estasTradukLingvoj = (tradukLingvoj.count > 0) ? 1 : 0
        let aldoniLingvon = (!tableView.isEditing) ? 1 : 0
        return estasTradukLingvoj + aldoniLingvon
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return (tradukLingvoj.count > 0) ? tradukLingvoj.count : 1
        }
        else if section == 1 {
            return (tradukLingvoj.count > 0) ? 1 : 0
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chelo = tableView.dequeueReusableCell(withIdentifier: tradukLingvojElektiloChelIdent) ?? UITableViewCell()
        
        if indexPath.section == 0 && tradukLingvoj.count > 0 {
            chelo.textLabel?.text = tradukLingvoj[indexPath.row].nomo
            chelo.accessoryType = .none
        }
        else {
            chelo.textLabel?.text = NSLocalizedString("traduk-elektilo aldoni-butono titolo", comment: "")
            chelo.accessoryType = .disclosureIndicator
        }
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aldonSekcio = (tradukLingvoj.count > 0 ) ? 1 : 0
        
        if indexPath.section == aldonSekcio {
            let navigaciilo = HelpaNavigationController()
            let elektilo = LingvoElektiloViewController()
            elektilo.starigi(titolo: NSLocalizedString("lingvo-elektilo traduka titolo", comment: ""),
                             suprajTitolo: NSLocalizedString("lingvo-elektilo serchataj etikedo", comment: ""),
                             montriEsperanton: false)
            elektilo.delegate = self
            navigaciilo.viewControllers.append(elektilo)
            self.navigationController?.present(navigaciilo, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tradukLingvoj.count == 0 || indexPath.section == 1 {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if tradukLingvoj.count == 0 || indexPath.section == 1 {
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tradukLingvoj.count > 0 && indexPath.section == 0) {
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let lingvo = tradukLingvoj[indexPath.row]
            tradukLingvoj.remove(at: indexPath.row)
            UzantDatumaro.tradukLingvoj.remove(lingvo)
            UzantDatumaro.elektisTradukLingvojn()
            shanghisLingvojn = true
            
            if tradukLingvoj.count == 0 {
                DispatchQueue.main.async {
                    tableView.setEditing(false, animated: true)
                    self.ghisdatigiRedaktadon()
                }
            }
            
            tableView.reloadData()
        }
    }
}

// MARK: - LingvoElektiloDelegate

extension TradukLingvojElektiloTableViewController: LingvoElektiloDelegate {
    func elektisLingvon(lingvo: Lingvo) {
        UzantDatumaro.tradukLingvoj.insert(lingvo)
        UzantDatumaro.elektisTradukLingvojn()
        shanghisLingvojn = true
        
        tradukLingvoj = kaptiTradukLingvojn()
        ghisdatigiButonon()
        tableView.reloadData()
    }
}

// MARK: - Helpiloj

extension TradukLingvojElektiloTableViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        tableView.reloadData()
    }
}
