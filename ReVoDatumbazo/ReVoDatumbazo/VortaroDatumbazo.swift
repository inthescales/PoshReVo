//
//  DatumbazAlirilo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

/// Venigas datumojn el la datumbazo, kaj liveras ilin diversforme (t.e. kiel `Lingvon`, `Fakon`, ktp., kaj ne datumbazobjekton)
public final class VortaroDatumbazo {

    private let alirilo: DatumbazAlirilo

    public init(konteksto: NSManagedObjectContext) {
        alirilo = DatumbazAlirilo(konteksto: konteksto)
    }
    
    // MARK: - Modeloserĉado
    
    public func lingvo(porKodo kodo: String) -> Lingvo? {
        if let objekto = alirilo.lingvo(porKodo: kodo) {
			return Lingvo.el(objekto)
        }
        return nil
    }
    
    public func fako(porKodo kodo: String) -> Fako? {
        if let objekto = alirilo.fako(porKodo: kodo) {
            return Fako.elDatumbazObjekto(objekto)
        }
        return nil
    }
    
    public func artikolo(porIndekso indekso: String) -> Artikolo? {
        if let objekto = alirilo.artikolo(porIndekso: indekso) {
			return Artikolo.elDatumbazObjekto(objekto: objekto, alirilo: alirilo)
        }
        
        return nil
    }
	
	public func artikolo(de destino: Destino) -> Artikolo? {
		Artikolo.elDatumbazObjekto(objekto: destino.artikolObjekto, alirilo: alirilo)
	}

    public func iuAjnArtikolo() -> Artikolo? {
        if let objekto = alirilo.iuAjnArtikolo() {
            return Artikolo.elDatumbazObjekto(objekto: objekto, alirilo: alirilo)
        }
        
        return nil
    }
    
    // MARK: - Klasoj de modeloj
    
    public func vortoj(oficialeco: String) -> [Artikolo] {
        alirilo.vortoj(oficialeco: oficialeco)?.compactMap { objekto in
            Artikolo.elDatumbazObjekto(objekto: objekto, alirilo: alirilo)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs.titolo < rhs.titolo
        } ?? []
    }
    
    public func fakVortoj(porFako kodo: String) -> [Destino] {
        alirilo.fakVortoj(porFako: kodo)?.compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        } ?? []
    }
    
    public func ofcVortoj(porOficialeco kodo: String) -> [Destino] {
        alirilo.ofcVortoj(porOficialeco: kodo)?.compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        } ?? []
    }
    
    // MARK: - Chiuj modeloj
    
    public func chiujLingvoj() -> [Lingvo] {
        alirilo.chiujLingvoj().compactMap { objekto in
            Lingvo.el(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    public func chiujFakoj() -> [Fako] {
        alirilo.chiujFakoj().compactMap { objekto in
            Fako.elDatumbazObjekto(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
        
    public func chiujOficialecoj() -> [Oficialeco]? {
        alirilo.chiujOficialecoj().compactMap { objekto in
            Oficialeco.elDatumbazObjekto(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    // MARK: - Trie-serĉado
    
    public func komenciSerchon(lingvo: Lingvo, teksto: String, komenco: Int? = 0, limo: Int) -> SerchStato {
        if let iterator = alirilo.starigiTrieIterator(lingvo: lingvo.kodo, peto: teksto) {
            let komencaStato = SerchStato(iterator: iterator, rezultoj: [], peto: teksto, atingisFinon: false)
            return daurigiSerchon(stato: komencaStato, limo: limo)
        }
        return SerchStato(iterator: TrieIterator(lingvoKodo: lingvo.kodo, peto: teksto, komencaNodo: nil),
                          rezultoj: [],
                          peto: teksto,
                          atingisFinon: true)
    }
    
    public func daurigiSerchon(stato: SerchStato, limo: Int) -> SerchStato {
        let rezultObjektoj = alirilo.serchi(iterator: stato.iterator, limo: limo)
        let novajRezultoj = rezultObjektoj.compactMap { rezulto in
            (
                rezulto.0,
                rezulto.1.compactMap {
                    Destino(objekto: $0)
                }
            )
        }
        return SerchStato(iterator: stato.iterator,
                          rezultoj: stato.rezultoj + novajRezultoj,
                          peto: stato.peto,
                          atingisFinon: novajRezultoj.isEmpty)
    }
}
