//
//  SerchPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

import ReVoModeloj
import ReVoDatumbazo

let serchChelIdent = "serchRezultoChelo"
let serchLimo = 32

/*
    Pagho por serchi vortojn en la vortaro
*/
class SerchPaghoViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    var lastaSercho: (Lingvo, String)? = nil
    var serchStato: SerchStato?
    var serchRezultoj: [(String, [Destino])] {
        return serchStato?.rezultoj ?? [(String, [Destino])]()
    }
    
    init() {
        super.init(nibName: "SerchPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        serchTabulo?.delegate = self
        serchTabulo?.placeholder = NSLocalizedString("serchi tabulo teksto", comment: "")
        if #available(iOS 13.0, *) {
            serchTabulo?.searchTextField.isAccessibilityElement = true
            serchTabulo?.searchTextField.accessibilityIdentifier = "serchTabulaTekstejo"
        } else {
            serchTabulo?.isAccessibilityElement = true
            serchTabulo?.accessibilityIdentifier = "serchTabulo"
        }
        
        trovTabelo?.delegate = self
        trovTabelo?.dataSource = self
        trovTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: serchChelIdent)

        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        efektivigiStilon()
    }

    func aranghiNavigaciilo() {
        
        ghisdatigiTitolon()
        prepariNavigaciajnButonojn()
    }
    
    func efektivigiStilon() {
        
        serchTabulo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        serchTabulo?.barStyle = UzantDatumaro.stilo.serchTabuloKoloro
        serchTabulo?.keyboardAppearance = UzantDatumaro.stilo.klavaroKoloro
        serchTabulo?.tintColor = UzantDatumaro.stilo.tintKoloro
        
        trovTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        trovTabelo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        trovTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        trovTabelo?.reloadData()
    }
    
    func ghisdatigiTitolon() {
        
        if UzantDatumaro.serchLingvo.kodo.count > 0 {
            parent?.title = String(format: NSLocalizedString("serchi lingva titolo", comment: ""), arguments: [UzantDatumaro.serchLingvo.nomo])
        } else {
            parent?.title = NSLocalizedString("serchi baza titolo", comment: "")
        }
    }
    
    func prepariNavigaciajnButonojn() {
        
        let butonujo = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))

        let elektiloButono = UIButton()
        elektiloButono.setImage(UIImage(named: "pikto_traduko")?.withRenderingMode(.alwaysTemplate), for: .normal)
        elektiloButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        elektiloButono.addTarget(self, action: #selector(elektiLingvon), for: .touchUpInside)
        elektiloButono.accessibilityLabel = "elekti lingvon"
        
        let lastaButono = UIButton(type: .system)
        if UzantDatumaro.oftajSerchLingvoj.count > 1 {
            let lastaKodo = UzantDatumaro.oftajSerchLingvoj[1].kodo
            lastaButono.setTitle(lastaKodo, for: .normal)
            lastaButono.titleLabel?.textColor = UzantDatumaro.stilo.navTintKoloro
            lastaButono.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            lastaButono.tintColor = UzantDatumaro.stilo.navTintKoloro
            lastaButono.addTarget(self, action: #selector(uziLastanLingvon), for: .touchUpInside)
        }
        lastaButono.accessibilityLabel = "lasta lingvo"
        
        butonujo.addSubview(lastaButono)
        butonujo.addSubview(elektiloButono)
        elektiloButono.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        lastaButono.frame = CGRect(x: 0, y: -1, width: 30, height: 30)
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butonujo)
    }
    
    @objc func elektiLingvon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = LingvoElektiloViewController()
        elektilo.starigi(titolo: NSLocalizedString("lingvo-elektilo sercha titolo", comment: ""),
                         suprajTitolo: NSLocalizedString("lingvo-elektilo lastaj etikedo", comment: ""))
        elektilo.delegate = self
        navigaciilo.viewControllers.append(elektilo)
        self.navigationController?.present(navigaciilo, animated: true, completion: nil)
    }
    
    @objc func uziLastanLingvon() {
        if UzantDatumaro.oftajSerchLingvoj.count > 1 {
            let lasta = UzantDatumaro.oftajSerchLingvoj[1]
            UzantDatumaro.elektisSerchLingvon(lasta)
            elektisLingvon(lingvo: lasta)
        }
    }
    
    func fariSerchon(teksto: String) {
        if UzantDatumaro.serchLingvo != lastaSercho?.0 || teksto != lastaSercho?.1 {
            serchStato = VortaroDatumbazo.komuna.komenciSerchon(lingvo: UzantDatumaro.serchLingvo, teksto: teksto, komenco: 0, limo: serchLimo)
            trovTabelo?.reloadData()
            lastaSercho = (UzantDatumaro.serchLingvo, teksto)
        }
    }
    
    func venigiPli() {
        if let stato = serchStato, !stato.atingisFinon {
            serchStato = VortaroDatumbazo.komuna.daurigiSerchon(stato: stato, limo: serchLimo)
            DispatchQueue.main.async {
                self.trovTabelo?.reloadData()
            }
        }
    }
    
    // MARK: Publikajn metodojn
    
    public func renovigiSerchon() {
        serchTabulo?.text = ""
        serchStato = nil
        trovTabelo?.reloadData()
    }
}

// MARK: UISearchBarDelegate

extension SerchPaghoViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let teksto = searchBar.text else {
            return true
        }
        
        // Ĉapeli literojn
        if UzantDatumaro.serchLingvo == Lingvo.esperanto
            && text == "x"
            && teksto.count > 0 {
            
            let chapelita = Iloj.chapeliFinon(teksto)
            if chapelita != teksto {
                searchBar.text = chapelita
                self.searchBar(searchBar, textDidChange: teksto)
                return false
            }
        }
        
        // Chi tiu abomenajho necesas char japanaj klavaroj ne kauzas textDidChange, kaj la fina teksto ne disponeblas chi tie
        // Espereble Apple riparos tion estontece
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.3 * Double(NSEC_PER_SEC)) ) {
            [weak self] in
            self?.fariSerchon(teksto: self?.serchTabulo?.text! ?? "")
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchBar.text?.lowercased()
        if let teksto = searchBar.text {
            
            if !teksto.isEmpty {
                fariSerchon(teksto: teksto)
            } else {
                serchStato = nil
                lastaSercho = nil
                trovTabelo?.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension SerchPaghoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serchRezultoj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo = UITableViewCell(style: .value1, reuseIdentifier: serchChelIdent)
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = serchRezultoj[indexPath.row].0
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text

        if UzantDatumaro.serchLingvo != Lingvo.esperanto {
            novaChelo.detailTextLabel?.text = tekstoPorDestinoj(destinoj: serchRezultoj[indexPath.row].1)
        }
        
        if indexPath.row > serchRezultoj.count - 5 {
            venigiPli()
        }
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		let destinoj = serchRezultoj[indexPath.row].1
		if destinoj.count == 1 {
            if let destino = serchRezultoj[indexPath.row].1.first,
			   let artikolo = VortaroDatumbazo.komuna.artikolo(de: destino) {
                parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("serchi baza titolo", comment: ""), style: .plain, target: nil, action: nil)
                if let marko = serchRezultoj[indexPath.row].1.first?.marko, !marko.isEmpty {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
                } else {
                    (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo)
                }
            }
		} else if destinoj.count > 1 {
            let disigilo = VortoDisigiloViewController(endestinoj: serchRezultoj[indexPath.row].1)
            navigationController?.pushViewController(disigilo, animated: true)
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

// MARK: - LingvoElektiloDelegate
extension SerchPaghoViewController : LingvoElektiloDelegate {
    
    func elektisLingvon(lingvo: Lingvo) {
        UzantDatumaro.elektisSerchLingvon(lingvo)
        ghisdatigiTitolon()
        prepariNavigaciajnButonojn()
        fariSerchon(teksto: serchTabulo?.text ?? "")
    }
}

// MARK: - Helpiloj

extension SerchPaghoViewController {
    
    func tekstoPorDestinoj(destinoj: [Destino]) -> String {
        
        var bonaNomo: String = ""
        if destinoj.count == 1 {
            bonaNomo = (destinoj.first?.subteksto)?.components(separatedBy: ", ").first ?? ""
            if let senco = destinoj.first?.senco, senco != "0" {
                bonaNomo += Iloj.superLit(senco)
            }
            return bonaNomo
        } else {
            return String(destinoj.count) + " rezultoj"
        }
    }
}

// Respondi al mediaj shanghoj
extension SerchPaghoViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        trovTabelo?.reloadData()
    }
}
