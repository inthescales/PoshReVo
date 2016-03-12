//
//  SerchPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let serchChelIdent = "serchRezultoChelo"
let serchLimo = 32

class SerchPaghoViewController : UIViewController, Chefpagho {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    var serchRezultoj = [(String, NSManagedObject)]()
    
    override func viewDidLoad() {
        
        serchTabulo?.delegate = self
        
        trovTabelo?.delegate = self
        trovTabelo?.dataSource = self
        trovTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: serchChelIdent)
        trovTabelo?.reloadData()
    }
    
    func aranghiNavigaciilo() {
        
        ghisdatigiTitolon()
        
        let dekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: "elektiLingvon")
        dekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        parentViewController?.navigationItem.rightBarButtonItem = dekstraButono
    }
    
    func ghisdatigiTitolon() {
        parentViewController?.title = "Serchi (" + UzantDatumaro.serchLingvo.nomo + ")"
    }
    
    func elektiLingvon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = SerchLingvoElektiloViewController()
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        self.navigationController?.presentViewController(navigaciilo, animated: true, completion: nil)
    }
}

extension SerchPaghoViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let teksto = searchBar.text?.lowercaseString {
            
            if !teksto.isEmpty {
                serchRezultoj = TrieRegilo.serchi(UzantDatumaro.serchLingvo.kodo, teksto: teksto, limo: serchLimo)
                trovTabelo?.reloadData()
            }
        }
    }
}

extension SerchPaghoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serchRezultoj.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = trovTabelo?.dequeueReusableCellWithIdentifier(serchChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.textLabel?.text = serchRezultoj[indexPath.row].0
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let artikolObjekto = serchRezultoj[indexPath.row].1.valueForKey("artikolo") as? NSManagedObject {
            if let artikolo = Artikolo(objekto: artikolObjekto) {
                
                (navigationController as? ChefaNavigationController)?.nomiPostilo("Serĉi")
                if let marko = serchRezultoj[indexPath.row].1.valueForKey("marko") as? String where !marko.isEmpty {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                } else {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SerchPaghoViewController : SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon() {
        ghisdatigiTitolon()
    }
}
