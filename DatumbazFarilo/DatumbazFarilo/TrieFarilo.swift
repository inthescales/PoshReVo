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

/// Faras prefiksarbon por artikolserĉado
final class TrieFarilo {
	// TODO: Movi al ReVoDatumbazon?
    let konteksto: NSManagedObjectContext
	let tradukaro: [String: [SerchTraduko]]
    
	init(konteksto: NSManagedObjectContext, tradukaro: [String: [SerchTraduko]]) {
        self.konteksto = konteksto
		self.tradukaro = tradukaro
    }
    
    func konstruiChiuTrie(kodoj: [String]) {
        for lingvo in kodoj {
            konstruiTriePorLingvo(kodo: lingvo)
        }
    }
    
    func konstruiTriePorLingvo(kodo: String) {
        print("Kreas trie-on por " + kodo)
		
		guard let lingvo = Datumbaza.lingvo(porKodo: kodo),
			  let tradukoj = tradukaro[kodo] else {
			  return
		  }
        
		for traduko in tradukoj {
			// TODO: Ĉu necesas aldoni videblaTekston?
			let klavoj = (traduko.serchTeksto == traduko.videblaTeksto)
				? [traduko.serchTeksto]
				: [traduko.serchTeksto, traduko.videblaTeksto]
			
			for klavo in klavoj {
				var nunaNodo: NSManagedObject?
				
				for (i, litero) in klavo.lowercased().enumerated() {
					var sekvaNodo: NSManagedObject?
					
					// TODO: Eligi unuan literon el iteracio
					if i == 0 {
						sekvaNodo = akiriKomencanNodon(el: lingvo, kunLitero: String(litero))
							?? fariKomencanNodon(por: lingvo, litero: String(litero), en: konteksto)
					} else {
						sekvaNodo = akiriSekvanNodon(el: nunaNodo!, kunLitero: String(litero))
							?? fariSekvanNodon(por: nunaNodo!, litero: String(litero), en: konteksto)
					}
					
					nunaNodo = sekvaNodo
				}
				
				fariDestinon(el: traduko, por: nunaNodo!, en: konteksto)
			}
		}
		
		try! konteksto.save()
    }
	
	// MARK: - Helpiloj
	
	/// Kreas nodon, aldonante ĝin kiel komencan nodon al lingvo
	private func fariKomencanNodon(por lingvo: NSManagedObject, litero: String, en konteksto: NSManagedObjectContext) -> NSManagedObject {
		let novaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
		novaNodo.setValue(litero, forKey: "litero")
		lingvo.mutableSetValue(forKey: "komencajNodoj").add(novaNodo)
		
		return novaNodo
	}
	
	/// Kreas nodon, aldonante ĝin kiel sekvan nodon al alia nodo
	private func fariSekvanNodon(por nodo: NSManagedObject, litero: String, en konteksto: NSManagedObjectContext) -> NSManagedObject {
		let novaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
		novaNodo.setValue(litero, forKey: "litero")
		nodo.mutableSetValue(forKey: "sekvajNodoj").add(novaNodo)
		
		return novaNodo
	}
	
	/// Kreas destinon el SerchTraduko
	func fariDestinon(el traduko: SerchTraduko, por nodo: NSManagedObject, en konteksto: NSManagedObjectContext) {
		guard let artikolo = Datumbaza.artikolo(porIndekso: traduko.indekso) else {
			assert(false, "Ne trovis artikolon '\(traduko.indekso)'")
		}
		
		let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
		novaDestino.setValue(traduko.videblaTeksto, forKey: "teksto")
		novaDestino.setValue(traduko.indekso, forKey: "indekso")
		novaDestino.setValue(traduko.esperantaNomo, forKey: "nomo")
		novaDestino.setValue(traduko.marko, forKey: "marko")
		traduko.senco.flatMap {	novaDestino.setValue(String($0), forKey: "senco") }
		novaDestino.setValue(artikolo, forKey: "artikolo")
		nodo.mutableOrderedSetValue(forKey: "destinoj").add(novaDestino)
	}
	
	/// Liveras ĉiuj komencajn trie-nodojn de certa lingva NSManagedObject
	private func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
		return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
	}
	
	/// Liveras NSManagedObject-on reprezentantan komencan trie-nodon por certa lingvo kaj litero
	private func akiriKomencanNodon(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
			
		let nodoj = komencajNodojPorLingvo(lingvo)
		
		if let trovo = nodoj.firstIndex(where: {
			(kontrol: NSManagedObject) -> Bool in
			return kontrol.value(forKey: "litero") as? String == litero
		}) {
			return nodoj[trovo]
		}
		
		return nil
	}
	
	/// Liveras NSManagedObject-on reprezentantan sekvan trie-nodon el certa nodo laŭ certa litero
	private func akiriSekvanNodon(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
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

