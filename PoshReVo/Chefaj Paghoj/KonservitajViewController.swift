//
//  KonservitajViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

let konservitajChelIdent = "konservitajChelo"

/*
    Pagho por vidi konservitaj artikoloj
*/
class KonservitajViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var vortoTabelo: UITableView?
    
    init() {
        super.init(nibName: "KonservitajViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        vortoTabelo?.delegate = self
        vortoTabelo?.dataSource = self
        vortoTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: konservitajChelIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        parent?.title = NSLocalizedString("konservitaj titolo", comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        vortoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        vortoTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        vortoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        vortoTabelo?.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension KonservitajViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UzantDatumaro.konservitaj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = vortoTabelo?.dequeueReusableCell(withIdentifier: konservitajChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = UzantDatumaro.konservitaj[indexPath.row].nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indekso = UzantDatumaro.konservitaj[indexPath.row].indekso
        if let artikolo = SeancDatumaro.artikoloPorIndekso(indekso) {
            (navigationController as? ChefaNavigationController)?.montriArtikolon( artikolo )
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
extension KonservitajViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        vortoTabelo?.reloadData()
    }
}
