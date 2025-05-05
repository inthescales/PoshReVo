//
//  ArtikolChelo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

class ArtikoloTableViewCell : UITableViewCell, Stilplena {
    
    @IBOutlet var titolaRegiono: UIView?
    @IBOutlet var titolaEtikedo: TTTAttributedLabel?
    @IBOutlet var chefaEtikedo: TTTAttributedLabel?
    
    var subart: Bool = false
    
	func prepari(titolo: String, teksto: String) {
        
        titolaEtikedo?.setText(titolo)
        titolaEtikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body);
        
        chefaEtikedo?.text = Iloj.forigiAngulojn(teksto: teksto)
        efektivigiStilon()
        
        let markoj = Iloj.troviMarkojn(teksto: teksto)
        chefaEtikedo?.setText(Iloj.pretigiTekston(teksto, kunMarkoj: markoj))
        
        for ligMarko in markoj[markoLigoKlavo]! {
            chefaEtikedo?.addLink( to: URL(string: ligMarko.2), with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }

    }
}

// MARK: - Stilplena

extension ArtikoloTableViewCell {
    
    func efektivigiStilon() {
        
        backgroundColor = UzantDatumaro.stilo.bazKoloro
        titolaEtikedo?.textColor = UzantDatumaro.stilo.difinKapTekstKoloro
        titolaRegiono?.backgroundColor = UzantDatumaro.stilo.difinKapFonKoloro
        chefaEtikedo?.textColor = UzantDatumaro.stilo.tekstKoloro

        chefaEtikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
        chefaEtikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
    }
    
}
