//
//  ArtikoloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

import ReVoDatumbazo

let subArtikolChelIdent = "subArtikolaChelo"
let artikolChelIdent = "artikolaChelo"
let artikolKapIdent  = "artikolaKapo"
let artikolPiedIdent = "artikolaPiedo"
let artikolNevideblaPiedoIdent = "artikolaNevideblaPiedo"

/*
    Pagho kiu montras la artikolojn kun difinoj kaj tradukoj
*/
class ArtikoloViewController : UIViewController, Stilplena {
    
    private enum ChelSpeco {
        case Vorto(titolo: String, teksto: String), GrupKapo(titolo: String?, teksto: String?), Traduko(titolo: String, teksto: String)
    }
    
    @IBOutlet var vortTabelo: UITableView?
    var artikolo: Artikolo? = nil
    var tradukListo: [Traduko]? = nil
    var konservitaMarko: String? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(enartikolo: Artikolo) {
    
        super.init(nibName: "ArtikoloViewController", bundle: nil)
        artikolo = enartikolo
    }
    
    init?(enartikolo: Artikolo, enmarko: String) {
        super.init(nibName: "ArtikoloViewController", bundle: nil)
        artikolo = enartikolo
        konservitaMarko = enmarko
    }
    
    override func viewDidLoad() {

        prepariTradukListon()
        prepariNavigaciajnButonojn()
        
        title = (artikolo?.titolo ?? "") + Iloj.superLit((artikolo?.ofc ?? ""))
        
        vortTabelo?.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            vortTabelo?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        vortTabelo?.delegate = self
        vortTabelo?.dataSource = self
        vortTabelo?.register(UINib(nibName: "ArtikoloTableViewCell", bundle: nil), forCellReuseIdentifier: artikolChelIdent)
        vortTabelo?.register(UINib(nibName: "SubArtikoloTableViewCell", bundle: nil), forCellReuseIdentifier: subArtikolChelIdent)
        vortTabelo?.register(UINib(nibName: "ArtikoloKapoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolKapIdent)
        vortTabelo?.register(UINib(nibName: "ArtikoloPiedButonoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: artikolPiedIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(elektisTradukLingvojn), name: NSNotification.Name(rawValue: AtentigoNomoj.elektisTradukLingvojn), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        efektivigiStilon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if konservitaMarko != nil {
            DispatchQueue.main.async { [weak self] in
                self?.saltiAlMarko(self?.konservitaMarko ?? "", animacii: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let veraArtikolo = artikolo {
            UzantDatumaro.visitisPaghon(Listero(veraArtikolo.titolo, veraArtikolo.indekso))
        }
    }
    
    // MARK: - View-agordado
    
    func prepariNavigaciajnButonojn() {
        
        // Por meti du butonoj malproksime unu al la alia, oni devas krei UIView kiu enhavas
        // du UIButton-ojn, kaj uzi tion kiel la vera rightBarButtonItem
        
        let butonujo = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        
        // Elekti plena stelo se la artikolo estas konservia, alie la malplena
        let bildo = UzantDatumaro.konservitaj.contains { (nuna: Listero) -> Bool in
            return nuna.indekso == artikolo?.indekso
            } ? UIImage(named: "pikto_stelo_plena") : UIImage(named: "pikto_stelo")
        
        let konservButono = UIButton()
        konservButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        konservButono.setImage(bildo?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        konservButono.addTarget(self, action: #selector(premisKonservButonon), for: UIControl.Event.touchUpInside)
        konservButono.imageView?.contentMode = .scaleAspectFit
        
        let serchButono = UIButton()
        serchButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        serchButono.setImage(UIImage(named: "pikto_lupeo")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        serchButono.addTarget(self, action: #selector(premisSerchButonon), for: .touchUpInside)
        serchButono.contentHorizontalAlignment = .right
        
        butonujo.addSubview(konservButono)
        butonujo.addSubview(serchButono)
        serchButono.frame = CGRect(x: 34, y: 0, width: 36, height: 30)
        konservButono.frame = CGRect(x: 0, y: 0, width: 34, height: 30)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: butonujo)
    }
    
    // Krei liston de tradukoj por montri - tiuj kiuj estas kaj en la listo de
    // tradukoj por la artikolo kaj la elektitaj traduk-lingvoj
    func prepariTradukListon() {

        tradukListo = [Traduko]()
        
        for traduko in artikolo?.tradukoj ?? [] {
            if UzantDatumaro.tradukLingvoj.contains(traduko.lingvo) {
                tradukListo?.append(traduko)
            }
        }
        
        tradukListo?.sort(by: { (unua: Traduko, dua: Traduko) -> Bool in
            return unua.lingvo.nomo.compare(dua.lingvo.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        })
    }
    
    // MARK: - Stilplena
    
    func efektivigiStilon() {
        
        navigationController?.navigationBar.tintColor = UzantDatumaro.stilo.navTintKoloro
        vortTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        vortTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        vortTabelo?.reloadData()
    }
    
    // MARK: - Paĝ-agoj
    
    // Haste movi la ekranon al la dezirata vorto en la artikolo
    func saltiAlMarko(_ marko: String, animacii: Bool) {
        
        var sumo = 0
        for subartikolo in artikolo?.subartikoloj ?? [] {
            
            if artikolo?.subartikoloj.count ?? 0 > 1 { sumo += 1 }
            
            for vorto in subartikolo.vortoj {
                
                if vorto.marko == marko {
                    
                    vortTabelo?.scrollToRow(at: IndexPath(row: sumo, section: 0), at: .top, animated: animacii)
                    return
                }
                
                sumo += 1
            }
        }
    }
    
    // MARK: - UI agoj
    
    // Reiri al la ingo pagho kaj igi ghin montri la serch-paghon
    @objc func premisSerchButonon() {
        
        if let ingo = (navigationController as? ChefaNavigationController)?.viewControllers.first as? IngoPaghoViewController {
            ingo.montriPaghon(Pagho.Serchi)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Konservi au malkonservi la artikolon
    @objc func premisKonservButonon() {
        
        UzantDatumaro.shanghiKonservitecon(artikolo: Listero(artikolo!.titolo, artikolo!.indekso))
        prepariNavigaciajnButonojn()
    }
    
    // Montri la traduk-lingvoj elektilon
    @objc func premisPliajnTradukojnButonon() {
        
        let navigaciilo = HelpaNavigationController()
        let elektilo = TradukLingvojElektiloTableViewController(style: .grouped)
        navigaciilo.viewControllers.append(elektilo)
        navigationController?.present(navigaciilo, animated: true, completion: nil)
    }
    
    @objc func premisChelon(_ rekonilo: UILongPressGestureRecognizer) {
        
        if let chelo = rekonilo.view as? ArtikoloTableViewCell, rekonilo.state == .began {
            let mesagho: UIAlertController = UIAlertController(title: NSLocalizedString("artikolo chelo agoj titolo", comment: ""), message: nil, preferredStyle: .actionSheet)
            mesagho.addAction( UIAlertAction(title: NSLocalizedString("artikolo chelo ago kopii", comment: ""), style: .default, handler: { (ago: UIAlertAction) -> Void in
                let tabulo = UIPasteboard.general
                tabulo.string = chelo.chefaEtikedo?.text as? String ?? ""
            }))
            mesagho.addAction( UIAlertAction(title: NSLocalizedString("Nenio", comment: ""), style: .cancel, handler: nil))
            
            if let prezentilo = mesagho.popoverPresentationController {
                prezentilo.sourceView = chelo;
                prezentilo.sourceRect = chelo.bounds;
            }
            
            present(mesagho, animated: true, completion: nil)
        }
    }
    
    @objc func elektisTradukLingvojn() {
        
        prepariTradukListon()
        vortTabelo?.reloadSections(IndexSet(integer: 1), with: .fade)
        if vortTabelo?.numberOfRows(inSection: 1) ?? 0 > 0 {
            vortTabelo?.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ArtikoloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let tradukSumo = artikolo?.tradukoj.count ?? 0, videblaSumo = tradukListo?.count ?? 0
        return 1 + ((videblaSumo > 0 || tradukSumo - videblaSumo > 0) ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rez = 0
        if section == 0 {
            
            for subartikolo in artikolo!.subartikoloj {
                if artikolo?.subartikoloj.count ?? 0 > 1 { rez += 1 }
                rez += subartikolo.vortoj.count
            }
            return rez
        } else if section == 1 {
            
            rez = tradukListo?.count ?? 0
        }

        return rez
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let artikolo = artikolo else { fatalError("Devas esti artikolo") }
        
        let chelSpeco: ChelSpeco
        if indexPath.section == 0 {
            if artikolo.subartikoloj.count == 1 {
                let subartikolo = artikolo.subartikoloj.first!
                let vorto = subartikolo.vortoj[indexPath.row]
                chelSpeco = .Vorto(titolo: vorto.kunaTitolo, teksto: vorto.teksto)
            }
            else {
                if let vorto = vortoDeIndexPath(indexPath) {
                    chelSpeco = .Vorto(titolo: vorto.kunaTitolo, teksto: vorto.teksto)
                }
                else if let grupTeksto = grupTekstoDeIndexPath(indexPath) {
                    chelSpeco = .GrupKapo(titolo: nil, teksto: grupTeksto)
                }
                else {
                    fatalError("AHH")
                }
            }
        } else if indexPath.section == 1,
            let traduko = tradukListo?[indexPath.row] {
                chelSpeco = .Traduko(titolo: traduko.lingvo.nomo, teksto: traduko.teksto)
        } else {
            fatalError("Sekcia numero malvalidas")
        }
        
        switch chelSpeco {
            case .Vorto(let titolo, let teksto):
                let novaChelo = tableView.dequeueReusableCell(withIdentifier: artikolChelIdent, for: indexPath) as! ArtikoloTableViewCell
                pretigiArtikolaChelo(chelo: novaChelo, titolo: titolo, teksto: teksto)
                return novaChelo
            case .GrupKapo(let titolo, let teksto):
                let novaChelo = tableView.dequeueReusableCell(withIdentifier: subArtikolChelIdent, for: indexPath) as! SubArtikoloTableViewCell
                pretigiSubArtikolaChelo(chelo: novaChelo, titolo: titolo, teksto: teksto, unua: indexPath.row == 0)
                return novaChelo
            case .Traduko(let titolo, let teksto):
                let novaChelo = tableView.dequeueReusableCell(withIdentifier: artikolChelIdent, for: indexPath) as! ArtikoloTableViewCell
                pretigiArtikolaChelo(chelo: novaChelo, titolo: titolo, teksto: teksto)
                return novaChelo
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let novaKapo: ArtikoloKapoTableViewHeaderFooterView
        if let trovKapo = vortTabelo?.dequeueReusableHeaderFooterView(withIdentifier: artikolKapIdent) as? ArtikoloKapoTableViewHeaderFooterView {
            novaKapo = trovKapo
        } else {
            novaKapo = ArtikoloKapoTableViewHeaderFooterView()
        }
        
        if section == 1 {
            novaKapo.prepari()
            novaKapo.etikedo?.text = NSLocalizedString("artikolo tradukoj etikedo", comment: "")
        }
        
        return novaKapo
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 && tableView.numberOfSections > 1 {
            if let trovPiedo = vortTabelo?.dequeueReusableHeaderFooterView(withIdentifier: artikolNevideblaPiedoIdent) as? ArtikoloNevideblaTableHeaderFooterView {
                return trovPiedo
            }

            return ArtikoloNevideblaTableHeaderFooterView(frame: .zero)
        }
        else if section == 1 && artikolo?.tradukoj.count ?? 0 > 0 {
            
            let novaPiedo: ArtikoloPiedButonoTableViewHeaderFooterView
            if let trovPiedo = vortTabelo?.dequeueReusableHeaderFooterView(withIdentifier: artikolPiedIdent) as? ArtikoloPiedButonoTableViewHeaderFooterView {
                novaPiedo = trovPiedo
            } else {
                novaPiedo = ArtikoloPiedButonoTableViewHeaderFooterView()
            }
            
            novaPiedo.prepari()
            novaPiedo.butono?.addTarget(self, action: #selector(premisPliajnTradukojnButonon), for: .touchUpInside)
            
            return novaPiedo
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if section == 1 {
            return UITableView.automaticDimension
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 && tableView.numberOfSections > 1 {
            return 16
        }
        else if section == 1 {
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            return 50 + desc.pointSize - 14
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 32
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 && tableView.numberOfSections > 1 {
            return 16
        }
        else if section == 1 {
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            return 50 + desc.pointSize - 14
        }
        
        return 0
    }
}

// MARK: - Chelo-starigado

extension ArtikoloViewController {
    
    private func pretigiArtikolaChelo(chelo: ArtikoloTableViewCell, titolo: String, teksto: String) {
        chelo.prepari(titolo: titolo, teksto: teksto)
        chelo.chefaEtikedo?.delegate = self
        pretigiChelAccessibility(chelo: chelo, titolo: titolo, teksto: teksto)
        pretigiRekonilon(por: chelo)
    }
    
    private func pretigiSubArtikolaChelo(chelo: SubArtikoloTableViewCell, titolo: String?, teksto: String?, unua: Bool = false) {
        chelo.prepari(titolo: titolo, teksto: teksto, unua: unua)
        chelo.chefaEtikedo?.delegate = self
        pretigiChelAccessibility(chelo: chelo, titolo: titolo, teksto: teksto)
        pretigiRekonilon(por: chelo)
    }
    
    private func pretigiChelAccessibility(chelo: UITableViewCell, titolo: String?, teksto: String?) {
        chelo.isAccessibilityElement = true
        if titolo == nil || teksto == nil {
            chelo.accessibilityLabel = titolo ?? teksto
        }
        else if let titolo = titolo,
            let teksto = teksto {
            chelo.accessibilityLabel = [titolo, teksto].joined(separator: ",")
        }
    }
    
    private func pretigiRekonilon(por chelo: UITableViewCell) {
        for rekonilo in chelo.gestureRecognizers ?? [] {
            chelo.removeGestureRecognizer(rekonilo)
        }
        let rekonilo = UILongPressGestureRecognizer(target: self, action: #selector(premisChelon(_:)))
        chelo.addGestureRecognizer(rekonilo)
    }
}

// MARK: - TTTAttributedLabelDelegate

extension ArtikoloViewController : TTTAttributedLabelDelegate {
    // Uzanto premis ligilon - iri al la dezirata sekcio de la artikolo, au montri novan artikolon
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL?) {
        let marko = url?.absoluteString ?? ""
        let partoj = marko.components(separatedBy: ".")
        
        if partoj.count == 0 {
            return
        }
        
        if partoj[0] == artikolo?.indekso {
            if partoj.count >= 2 {
                saltiAlMarko(partoj[0] + "." + partoj[1], animacii: true)
            }
        } else {
            if let artikolo =  VortaroDatumbazo.komuna.artikolo(indekso: partoj[0]) {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: self.artikolo?.titolo, style: .plain, target: nil, action: nil)
                (self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
            }
        }
    }
}

// MARK: - Helpiloj

extension ArtikoloViewController {
    
    private func vortoDeIndexPath(_ indexPath: IndexPath) -> Vorto? {
        guard let artikolo = artikolo else { fatalError("Devas esti artikolo") }
        
        var sumo = 0
        for subartikolo in artikolo.subartikoloj {
            if sumo == indexPath.row {
                return nil
            }
            if indexPath.row < sumo + subartikolo.vortoj.count + 1 {
                return subartikolo.vortoj[indexPath.row - sumo - 1]
            }
            sumo += subartikolo.vortoj.count + 1
        }
        
        return nil
    }
    
    private func grupTekstoDeIndexPath(_ indexPath: IndexPath) -> String? {
        guard let artikolo = artikolo else { fatalError("Devas esti artikolo") }
        
        var sumo = 0
        for subartikolo in artikolo.subartikoloj {
            if sumo == indexPath.row {
                return subartikolo.teksto
            }
            if indexPath.row < sumo + subartikolo.vortoj.count + 1 {
                return nil
            }
            sumo += subartikolo.vortoj.count + 1
        }
        
        return nil
    }
    
    // Respondi al mediaj shanghoj
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        vortTabelo?.reloadData()
    }
}

