//
//  TrieIterator.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

final class TrieIterator {
	
    var nodStaplo = [(String, NSManagedObject)]()
    var destinojRestantaj = [(String, [NSManagedObject])]()
    let locale: Locale
    var atingisFinon: Bool
    
    init(lingvoKodo: String, peto: String, komencaNodo: NSManagedObject?) {
        locale = Locale(identifier: lingvoKodo)
        atingisFinon = false
        
        if let komencaNodo = komencaNodo {
            nodStaplo.append((peto, komencaNodo))
        }
    }

    func next() -> (String, [NSManagedObject])? {
        
        if let sekvaDestino = destinojRestantaj.popLast() {
            return sekvaDestino
        }
        
        while let (nomo, nodo) = nodStaplo.popLast() {
            
            if let filoj = ((nodo.mutableSetValue(forKey: "sekvajNodoj")).allObjects as? [NSManagedObject])?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
                let unuaLitero = (unua.value(forKey: "litero") as? String) ?? ""
                let duaLitero = (dua.value(forKey: "litero") as? String) ?? ""
                return unuaLitero.compare(duaLitero, options: .forcedOrdering, range: nil, locale: locale) == .orderedDescending
            }) {
                for filo in filoj {
                    if let litero = filo.value(forKey: "litero") as? String {
                        nodStaplo.append((nomo + litero, filo))
                    }
                }
            }
            
            if let destinoj = nodo.mutableOrderedSetValue(forKey: "destinoj").array as? [NSManagedObject] {
                
                // Grupigi destinojn lau videbla nomo
                var subartikolo = [String: [NSManagedObject]]()
                var donota: (String, [NSManagedObject])?
                
                for destino in destinoj {
                    if let videbla = destino.value(forKey: "teksto") as? String {
                        if subartikolo[videbla] == nil {
                            subartikolo[videbla] = [NSManagedObject]()
                        }
                        subartikolo[videbla]?.append(destino)
                    }
                }
                
                // Ordigi grupojn tiel ke la unua havu la bazan nomo, aliaj alfabetigitaj poste
                for klavo in subartikolo.keys.sorted(by: { (unuaVorto, duaVorto) -> Bool in
                    return unuaVorto.compare(duaVorto, options: .forcedOrdering, range: nil, locale: locale) == .orderedDescending
                }) {
                    if klavo == nomo {
                        donota = (klavo, subartikolo[klavo]!)
                    } else {
                        destinojRestantaj.append((klavo, subartikolo[klavo]!))
                    }
                }

                return donota ?? next()
            }
        }
        
        atingisFinon = true
        return nil
    }
}
