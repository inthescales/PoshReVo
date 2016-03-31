//
//  SerchPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let serchChelIdent = "serchRezultoChelo"
let serchLimo = 32

/*
    Pagho por serchi vortojn en la vortaro
*/
class SerchPaghoViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    var lastaSercho: String? = nil
    var serchRezultoj = [(String, [NSManagedObject])]()
    
    init() {
        super.init(nibName: "SerchPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        serchTabulo?.delegate = self
        serchTabulo?.placeholder = NSLocalizedString("serchi tabulo teksto", comment: "")
        serchTabulo?.isAccessibilityElement = true
        serchTabulo?.accessibilityLabel = serchTabulo?.placeholder
        
        trovTabelo?.delegate = self
        trovTabelo?.dataSource = self
        trovTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: serchChelIdent)

        efektivigiStilon()
    }
    
    func aranghiNavigaciilo() {
        
        ghisdatigiTitolon()
        
        let dekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_traduko"), style: UIBarButtonItemStyle.Plain, target: self, action: "elektiLingvon")
        dekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        parentViewController?.navigationItem.rightBarButtonItem = dekstraButono
    }
    
    func efektivigiStilon() {
        
        serchTabulo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        serchTabulo?.barStyle = UzantDatumaro.stilo.serchTabuloKoloro
        serchTabulo?.keyboardAppearance = UzantDatumaro.stilo.klavaroKoloro
        serchTabulo?.tintColor = UzantDatumaro.stilo.tintKoloro
        
        trovTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        trovTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        trovTabelo?.reloadData()
    }
    
    func ghisdatigiTitolon() {
        
        if UzantDatumaro.serchLingvo.kodo.characters.count > 0 {
            parentViewController?.title = String(format: NSLocalizedString("serchi lingva titolo", comment: ""), arguments: [UzantDatumaro.serchLingvo.nomo])
        } else {
            parentViewController?.title = NSLocalizedString("serchi baza titolo", comment: "")
        }
    }
    
    func elektiLingvon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = SerchLingvoElektiloViewController()
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        self.navigationController?.presentViewController(navigaciilo, animated: true, completion: nil)
    }
    
    func fariSerchon(teksto: String) {
        if teksto != lastaSercho {
            serchRezultoj = TrieRegilo.serchi(UzantDatumaro.serchLingvo.kodo, teksto: teksto, limo: serchLimo)
            trovTabelo?.reloadData()
            lastaSercho = teksto
        }
    }
}

extension SerchPaghoViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var teksto = searchBar.text
        if UzantDatumaro.serchLingvo == SeancDatumaro.esperantaLingvo() && text == "x" && teksto?.characters.count > 0 {
            
            let lasta = teksto?[teksto!.endIndex.advancedBy(-1)]
            if let chapeligita = Iloj.chapeligi(lasta!) {
                teksto = teksto!.substringToIndex(teksto!.endIndex.advancedBy(-1)) + String(chapeligita)
            }
            
            searchBar.text = teksto!
            self.searchBar(searchBar, textDidChange: teksto!)
            return false
        }
        
        // Chi tiu abomenajho necesas char japanaj klavaroj ne kauzas textDidChange, kaj la fina teksto ne disponeblas chi tie
        // Espereble Apple riparos tion estontece
        if teksto != nil {
            weak var malforta = self
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                if let vera = malforta {
                    vera.fariSerchon(vera.serchTabulo?.text! ?? "")
                }
            });
        }
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchBar.text?.lowercaseString
        if let teksto = searchBar.text {
            
            if !teksto.isEmpty {
                fariSerchon(teksto)
            } else {
                serchRezultoj.removeAll()
                trovTabelo?.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
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
        
        /*let novaChelo: UITableViewCell
        if let trovChelo = trovTabelo?.dequeueReusableCellWithIdentifier(serchChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }*/
        let novaChelo = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: serchChelIdent)
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = serchRezultoj[indexPath.row].0
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        if serchRezultoj[indexPath.row].1.count == 1 {
            novaChelo.detailTextLabel?.text = nil
        } else {
            novaChelo.detailTextLabel?.text = String(serchRezultoj[indexPath.row].1.count) + " trovoj"
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if serchRezultoj[indexPath.row].1.count == 1 {
            if let artikolObjekto = serchRezultoj[indexPath.row].1.first?.valueForKey("artikolo") as? NSManagedObject {
                if let artikolo = Artikolo(objekto: artikolObjekto) {
                    
                    if let marko = serchRezultoj[indexPath.row].1.first?.valueForKey("marko") as? String where !marko.isEmpty {
                        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                    } else {
                        (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                    }
                }
            }
        } else {
            let disigilo = VortoDisigiloViewController(endestinoj: serchRezultoj[indexPath.row].1)
            navigationController?.pushViewController(disigilo, animated: true)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SerchPaghoViewController : SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon() {
        ghisdatigiTitolon()
        fariSerchon(serchTabulo?.text ?? "")
    }
}
