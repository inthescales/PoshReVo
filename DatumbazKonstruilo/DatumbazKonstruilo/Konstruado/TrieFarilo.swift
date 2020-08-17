//
//  TrieFarilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoDatumbazoOSX

/*
    La trie farilo faras la trie parton de la datumbazo
*/
final class TrieFarilo {
    
    let konteksto: NSManagedObjectContext
    let alirilo: DatumbazAlirilo
    let indeksojURL: URL
    
    init(konteksto: NSManagedObjectContext, datumoURL: URL) {
        self.konteksto = konteksto
        alirilo = DatumbazAlirilo(konteksto: konteksto)
        indeksojURL = datumoURL.appendingPathComponent("indeksoj/")
    }
    
    func konstruiChiuTrie(kodoj: [String]) {
        for lingvo in kodoj {
            konstruiTriePorLingvo(kodo: lingvo)
        }
    }
    
    func konstruiTriePorLingvo(kodo: String) {
        
        let tradukoURL = indeksojURL.appendingPathComponent("indekso_" + kodo + ".json")
            
        print("Kreas trie-on por " + kodo)
        let lingvoObjekto = alirilo.lingvo(porKodo: kodo)
        if lingvoObjekto == nil {
            return
        }
        
        do {
            let tradukoData = try Data(contentsOf: tradukoURL)
            let tradukoJSON = try JSONSerialization.jsonObject(with: tradukoData, options: JSONSerialization.ReadingOptions())
            
            if let tradukoj = tradukoJSON as? NSArray {
                
                var nunNodo: NSManagedObject? = nil
                for traduko in tradukoj {
                    
                    if let enhavoj = traduko as? NSDictionary {
                        // Kiel dict: indekso, senco, teksto, marko
                        
                        let videbla = enhavoj["videbla"] as? String
                        let teksto = enhavoj["teksto"] as? String
                        let nomo = enhavoj["nomo"] as? String
                        let indekso = enhavoj["indekso"] as? String
                        let marko = enhavoj["marko"] as? String
                        let senco = enhavoj["senco"] as! Int
                        
                        // Trovi klavojn
                        var klavoj = [String]()
                        if videbla != nil { klavoj.append(videbla!) }
                        if videbla != teksto { klavoj.append(teksto!) }
                        
                        for klavo in klavoj {
                            for nunLitero in klavo.lowercased() {
                                
                                var sekvaNodo: NSManagedObject? = nil
                                if nunNodo == nil {
                                    if let trovNodo = alirilo.komencaNodo(el: lingvoObjekto!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                } else {
                                    if let trovNodo = alirilo.sekvaNodo(el: nunNodo!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                }
                                
                                if sekvaNodo == nil {
                                    sekvaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
                                    sekvaNodo?.setValue(String(nunLitero), forKey: "litero")
                                    
                                    if nunNodo == nil {
                                        lingvoObjekto?.mutableSetValue(forKey: "komencajNodoj").add(sekvaNodo!)
                                    } else {
                                        nunNodo?.mutableSetValue(forKey: "sekvajNodoj").add(sekvaNodo!)
                                    }
                                }
                                
                                nunNodo = sekvaNodo
                                
                            }
                            
                            if indekso != nil {
                                let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
                                novaDestino.setValue(videbla, forKey: "teksto")
                                novaDestino.setValue(indekso, forKey: "indekso")
                                novaDestino.setValue(nomo, forKey: "nomo")
                                novaDestino.setValue(marko, forKey: "marko")
                                novaDestino.setValue(String(senco), forKey: "senco")
                                if let artikolo = alirilo.artikolo(porIndekso: indekso!) {
                                    novaDestino.setValue(artikolo, forKey: "artikolo")
                                }
                                nunNodo?.mutableOrderedSetValue(forKey: "destinoj").add(novaDestino)
                            }
                            
                            nunNodo = nil
                        } // Serch klavoj
                        
                    } // Enhavoj de la traduko
                    
                } // Chiu traduko
                
                try konteksto.save()
            }
        } catch {
            print("Eraro: Ne trovis datumojn por lingvo %@", kodo)
        }

    }
}

