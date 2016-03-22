//
//  PriViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

/*
    Informoj pri la programo, kaj ligoj al samtemaj retpaghoj
*/
class PriViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var etikedo: TTTAttributedLabel?
    
    init() {
        super.init(nibName: "PriViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("pri titolo", comment: "")
        let teksto = NSLocalizedString("pri teksto", comment: "")
    
        etikedo?.delegate = self
        
        efektivigiStilon()
        let markoj = Iloj.troviMarkojn(teksto)
        etikedo?.setText(Iloj.pretigiTekston(teksto, kunMarkoj: markoj))
        for ligMarko in markoj[markoLigoKlavo]! {
            etikedo?.addLinkToURL( NSURL(string: ligMarko.2), withRange: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }
    }
    
    func aranghiNavigaciilo() {
        
        parentViewController?.title = NSLocalizedString("pri titolo", comment: "")
        parentViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        view.backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        etikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
        etikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
    }
}

extension PriViewController : TTTAttributedLabelDelegate {
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        UIApplication.sharedApplication().openURL(url)
    }
}