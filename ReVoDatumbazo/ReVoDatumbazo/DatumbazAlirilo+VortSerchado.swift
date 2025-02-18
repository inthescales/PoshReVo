//
//  DatumbazAlirilo+VortSerchado.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/16/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import CoreData

extension DatumbazAlirilo {
    
    // MARK: - Serĉado
 
    func starigiTrieIterator(lingvo: String, peto: String) -> TrieIterator? {
        
        guard peto.count > 0,
            let komencaNodo = komencaNodo(por: lingvo , kunLitero: String(peto.prefix(1))) else {
            return nil
        }
        
        var nunNodo = komencaNodo
        for nunLitero in String(peto.suffix(peto.count - 1)) {
            if let sekvaNodo = sekvaNodo(el: nunNodo, kunLitero: String(nunLitero)) {
                nunNodo = sekvaNodo
            }
            else {
                return nil
            }
        }
        
        return TrieIterator(lingvoKodo: lingvo, peto: peto, komencaNodo: nunNodo)
    }
    
    func serchi(iterator: TrieIterator, limo: Int) -> [(String, [NSManagedObject])] {
        guard !iterator.atingisFinon else {
            return []
        }
        
        var rezultoj = [(String, [NSManagedObject])]()
        
        for _ in 0..<limo {
            if let sekva = iterator.next() {
                rezultoj.append(sekva)
            }
            else {
                break
            }
        }
        
        return rezultoj
    }
    
    // MARK: - Hepiloj
    
    private func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
        
        return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
    }

    private func komencaNodo(por kodo: String, kunLitero litero: String) -> NSManagedObject? {
        
        guard let lingvoObjekto = lingvo(porKodo: kodo) else {
            return nil
        }
        
        return komencaNodo(el: lingvoObjekto, kunLitero: litero)
    }
    
    private func komencaNodo(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
            
        let nodoj = komencajNodojPorLingvo(lingvo)
        
        if let trovo = nodoj.firstIndex(where: {
            (kontrol: NSManagedObject) -> Bool in
            return kontrol.value(forKey: "litero") as? String == litero
        }) {
            return nodoj[trovo]
        }
        
        return nil
    }
    
    private func sekvaNodo(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
        if let sekvaj: [NSManagedObject] = (nodo.value(forKey: "sekvajNodoj") as? NSSet)?.allObjects as? [NSManagedObject] {
            
            if let trov = sekvaj.firstIndex(where: {
                (kontrol: NSManagedObject) -> Bool in
                return kontrol.value(forKey: "litero") as? String == litero
            }) {
                return sekvaj[trov]
            }
        }
        
        return nil
    }
}
