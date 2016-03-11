//
//  SeancDatumaro.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import CoreData

class SeancDatumaro {
    
    static var lingvoj: [Lingvo] = [Lingvo]()
    static var fakoj: [Fako] = [Fako]()
    static var stiloj: [Stilo] = [Stilo]()
    static var mallongigoj: [Mallongigo] = [Mallongigo]()
    
    static func starigi() {
        
        for lingvo in DatumLegilo.chiujLingvoj() ?? [] {
            
            if let kodo = lingvo.valueForKey("kodo") as? String,
               let nomo = lingvo.valueForKey("nomo") as? String {
                
                if kodo == "eo" {
                    lingvoj.append(esperantaLingvo())
                } else {
                    lingvoj.append( Lingvo(kodo, nomo) )
                }
            }
        }
        
        for fako in DatumLegilo.chiujFakoj() ?? [] {
            
            if let kodo = fako.valueForKey("kodo") as? String,
               let nomo = fako.valueForKey("nomo") as? String {
                fakoj.append( Fako(kodo, nomo) )
            }
        }

        for stilo in DatumLegilo.chiujStiloj() ?? [] {
            
            if let kodo = stilo.valueForKey("kodo") as? String,
               let nomo = stilo.valueForKey("nomo") as? String {
                stiloj.append( Stilo(kodo, nomo) )
            }
        }
        
        for mallongigo in DatumLegilo.chiujMallongigoj() ?? [] {
            
            if let kodo = mallongigo.valueForKey("kodo") as? String,
               let nomo = mallongigo.valueForKey("nomo") as? String {
                mallongigoj.append( Mallongigo(kodo, nomo) )
            }
        }
    }
    
    static func lingvoPorKodo(kodo: String) -> Lingvo? {
        
        if let indekso = lingvoj.indexOf ({ (nuna: Lingvo) -> Bool in
            return nuna.kodo == kodo
        }) {
            return lingvoj[indekso]
        }
        
        return nil
    }
    
    static func esperantaLingvo() -> Lingvo {
        return Lingvo("eo", "Esperanto")
    }
}