//
//  ArtikolChelo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

let bazaTitolaAlteco: CGFloat = 35

class ArtikoloTableViewCell : UITableViewCell, Stilplena {

    @IBOutlet var titolaRegiono: UIView?
    @IBOutlet var titolaEtikedo: TTTAttributedLabel?
    @IBOutlet var titolaAlteco: NSLayoutConstraint?
    @IBOutlet var chefaEtikedo: TTTAttributedLabel?
    
    var subart: Bool = false
    
    func prepari(titolo: String, teksto: String, subart: Bool) {
        
        titolaEtikedo?.setText(titolo)
        titolaEtikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body);
        
        chefaEtikedo?.text = Iloj.forigiAngulojn(teksto: teksto)
        self.subart = subart
        
        if subart {
            titolaAlteco?.constant = 0
        } else {
            titolaAlteco?.constant = bazaTitolaAlteco
        }
        
        efektivigiStilon()
        
        let markoj = Iloj.troviMarkojn(teksto: teksto)
        chefaEtikedo?.setText(Iloj.pretigiTekston(teksto, kunMarkoj: markoj))
        
        for ligMarko in markoj[markoLigoKlavo]! {
            chefaEtikedo?.addLink( to: URL(string: ligMarko.2), with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }

    }
    
    func efektivigiStilon() {
        
        if subart {
            backgroundColor = UzantDatumaro.stilo.fonKoloro
            chefaEtikedo?.textColor = UzantDatumaro.stilo.fonTekstKoloro
        } else {
            backgroundColor = UzantDatumaro.stilo.bazKoloro
            titolaEtikedo?.textColor = UzantDatumaro.stilo.difinKapTekstKoloro
            titolaRegiono?.backgroundColor = UzantDatumaro.stilo.difinKapFonKoloro
            chefaEtikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        }

        chefaEtikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
        chefaEtikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
    }
    
}
