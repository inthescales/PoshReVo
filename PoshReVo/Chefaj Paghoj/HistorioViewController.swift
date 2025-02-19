//
//  HistorioViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

import ReVoDatumbazo

let historiChelIdent = "historioChelo"

/*
    Pagho por vidi lastaj serchitaj vortoj
*/
class HistorioViewController : UIViewController, Chefpagho, Stilplena {

    @IBOutlet var vortoTabelo: UITableView?
    
    init() {
        super.init(nibName: "HistorioViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: historiChelIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        parent?.title = NSLocalizedString("historio titolo", comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        vortoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        vortoTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        vortoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        vortoTabelo?.reloadData()
    }
    
}

// MARK: - UITableViewDelegate + UITableViewDataSource

extension HistorioViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UzantDatumaro.historio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = vortoTabelo?.dequeueReusableCell(withIdentifier: historiChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = UzantDatumaro.historio[indexPath.row].nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indekso = UzantDatumaro.historio[indexPath.row].indekso
        if let artikolo = VortaroDatumbazo.komuna.artikolo(porIndekso: indekso) {
            (navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
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

// MARK: - Helpiloj

// Respondi al mediaj shanghoj
extension HistorioViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        vortoTabelo?.reloadData()
    }
}
