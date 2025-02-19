//
//  LingvoElektiloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

import ReVoDatumbazo

let lingvoElektiloChelIdent = "lingvoElektiloChelo"

/*
    Delegate por ke aliaj paghoj povos reagi al lingvo-elektado
*/
protocol LingvoElektiloDelegate {
    
    func elektisLingvon(lingvo: Lingvo)
}

/*
    Pagho por elekti lingvon.
    La unua sekcio povas montri lastaj elektitaj lingvoj, kaj sube videblas chiu lingvo
*/
final class LingvoElektiloViewController : UIViewController, Stilplena {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var lingvoTabelo: UITableView?
    
    private let chiujLingvoj = VortaroDatumbazo.komuna.chiujLingvoj()
    private var validajLingvoj: [Lingvo]?
    private var filtritajLingvoj: [Lingvo]? = nil
    
    private var suprajLingvoj: [Lingvo]?
    private var suprajTitolo: String?
    private var montriEsperanton: Bool = true
    
    var montrotajLingvoj: [Lingvo] {
        return filtritajLingvoj ?? validajLingvoj ?? chiujLingvoj
    }
    
    var delegate: LingvoElektiloDelegate?
    
    init() {
        super.init(nibName: "LingvoElektiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func starigi(titolo: String, suprajTitolo: String? = nil, montriEsperanton: Bool = true) {
        title = titolo
        self.suprajTitolo = suprajTitolo
        suprajLingvoj = UzantDatumaro.oftajSerchLingvoj

        self.montriEsperanton = montriEsperanton
        if !montriEsperanton {
            suprajLingvoj?.removeAll(where: { (lingvo) -> Bool in
                lingvo == Lingvo.esperanto
            })
            validajLingvoj = chiujLingvoj
            validajLingvoj?.removeAll(where: { (lingvo) -> Bool in
                lingvo == Lingvo.esperanto
            })
        }
    }
    
    override func viewDidLoad() {
        
        serchTabulo?.delegate = self
        
        lingvoTabelo?.delegate = self
        lingvoTabelo?.dataSource = self
        lingvoTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: lingvoElektiloChelIdent)

        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        efektivigiStilon()
    }
    
    // MARK: - Paĝ-informoj
    
    private func chiujSekcioj() -> Int {
        if suprajLingvoj == nil {
            return 0
        }
        else {
            return 1
        }
    }
    
    // MARK: - Paĝ-agoj
    
    func forigiSin() {
        
        if presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Stiplena
    
    func efektivigiStilon() {
        
        serchTabulo?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        serchTabulo?.barStyle = UzantDatumaro.stilo.serchTabuloKoloro
        serchTabulo?.keyboardAppearance = UzantDatumaro.stilo.klavaroKoloro
        serchTabulo?.tintColor = UzantDatumaro.stilo.tintKoloro
        
        lingvoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        lingvoTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        lingvoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        lingvoTabelo?.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension LingvoElektiloViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let teksto = searchBar.text else {
            return true
        }
        
        // Ĉapeli literojn
        if text == "x" && teksto.count > 0 {
            let chapelita = Iloj.chapeliFinon(teksto)
            if chapelita != teksto {
                searchBar.text = chapelita
                self.searchBar(searchBar, textDidChange: teksto)
                return false
            }
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchBar.text?.lowercased()
    
        if let teksto = searchBar.text, !teksto.isEmpty {
            filtritajLingvoj = Iloj.filtriLingvojn(teksto: teksto, lingvoj: chiujLingvoj, montriEsperanton: montriEsperanton)
        }
        else {
            filtritajLingvoj = nil
        }
        
        lingvoTabelo?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension LingvoElektiloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if filtritajLingvoj == nil && suprajLingvoj != nil {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filtritajLingvoj = filtritajLingvoj {
            return filtritajLingvoj.count
        }
        else {
            if section == chiujSekcioj() {
                return montrotajLingvoj.count
            } else if let suprajLingvoj = suprajLingvoj {
                return suprajLingvoj.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = lingvoTabelo?.dequeueReusableCell(withIdentifier: lingvoElektiloChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        let lingvo: Lingvo
        if let filtritajLingvoj = filtritajLingvoj {
            lingvo = filtritajLingvoj[indexPath.row]
        }
        else {
            if indexPath.section == chiujSekcioj() {
                lingvo = montrotajLingvoj[indexPath.row]
            } else if let suprajLingvoj = suprajLingvoj {
                lingvo = suprajLingvoj[indexPath.row]
            } else {
                fatalError("Mankas lingvo")
            }
        }
        
        novaChelo.textLabel?.text = lingvo.nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard suprajLingvoj != [] else {
            return nil
        }
        
        if filtritajLingvoj == nil {
            if section == 0 {
                return suprajTitolo
            } else if section == 1 {
                return NSLocalizedString("lingvo-elektilo chiuj etikedo", comment: "")
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var lingvo: Lingvo? = nil
        if let filtritajLingvoj = filtritajLingvoj {
            lingvo = filtritajLingvoj[indexPath.row]
        }
        else {
            if indexPath.section == chiujSekcioj() {
                lingvo = montrotajLingvoj[indexPath.row]
            } else {
                lingvo = suprajLingvoj?[indexPath.row]
            }
        }
        
        if let veraLingvo = lingvo, let delegate = delegate {
            delegate.elektisLingvon(lingvo: veraLingvo)
        }
        
        lingvoTabelo?.deselectRow(at: indexPath, animated: true)
        forigiSin()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Helpiloj

extension LingvoElektiloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        lingvoTabelo?.reloadData()
    }
}

