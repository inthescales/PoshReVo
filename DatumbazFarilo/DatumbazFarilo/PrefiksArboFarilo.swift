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
final class PrefiksArboFarilo {
	// TODO: Movi al ReVoDatumbazon?
    let konteksto: NSManagedObjectContext
	let serchVortoj: [SerchVorto]
	let tradukaro: [String: [SerchTraduko]]
    
	init(
		konteksto: NSManagedObjectContext,
		serchVortoj: [SerchVorto],
		tradukaro: [String: [SerchTraduko]]
	) {
        self.konteksto = konteksto
		self.serchVortoj = serchVortoj
		self.tradukaro = tradukaro
    }
    
    func konstruiChiunArbon(kodoj: [String]) {
		konstruiEsperantanArbon()
		
		for lingvo in kodoj.filter({ kodo in kodo != "eo" }) {
			konstruiNacilingvanTrieon(kodo: lingvo)
        }
    }
    
	func konstruiEsperantanArbon() {
		print("Kreas prefiksarbon por esperanto")
		aldoni(sercheblajn: serchVortoj, al: Datumbaza.lingvo(porKodo: "eo")!)
	}
	
	func konstruiNacilingvanTrieon(kodo: String) {
		// 'guard' estas necesa dum testado
		guard let tradukoj = tradukaro[kodo] else {
			return
		}
		
		print("Kreas prefiksarbon por " + kodo)
		aldoni(sercheblajn: tradukoj, al: Datumbaza.lingvo(porKodo: kodo)!)
	}
        
	func aldoni(sercheblajn sercheblaj: [Serchebla], al lingvo: NSManagedObject) {
		for serchebla in sercheblaj {
			// TODO: Ĉu necesas aldoni videblaTekston?
			for klavo in serchebla.klavoj {
				var nunaNodo: NSManagedObject?
				
				for (i, litero) in klavo.lowercased().enumerated() {
					// TODO: Eligi unuan literon el iteracio
					if i == 0 {
						nunaNodo = komencaNodo(en: lingvo, kun: String(litero))
							?? fariKomencanNodon(por: lingvo, litero: String(litero), en: konteksto)
					} else {
						nunaNodo = sekvaNodo(el: nunaNodo!, kun: String(litero))
							?? fariSekvanNodon(por: nunaNodo!, litero: String(litero), en: konteksto)
					}
				}
				
				fariDestinon(el: serchebla, por: nunaNodo!, en: konteksto)
			}
		}
		
		try! konteksto.save()
    }
	
	// MARK: - Helpiloj
	
	/// Liveras ĉiuj komencajn trie-nodojn de certa lingva
	private func komencajNodoj(por lingvo: NSManagedObject) -> [NSManagedObject] {
		return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
	}
	
	/// Liveras komencan trie-nodon por certa lingvo kaj litero
	private func komencaNodo(en lingvo: NSManagedObject, kun litero: String) -> NSManagedObject? {
			
		let nodoj = komencajNodoj(por: lingvo)
		
		if let trovo = nodoj.firstIndex(where: {
			(kontrol: NSManagedObject) -> Bool in
			return kontrol.value(forKey: "litero") as? String == litero
		}) {
			return nodoj[trovo]
		}
		
		return nil
	}
	
	/// Liveras sekvan trie-nodon el certa nodo laŭ certa litero
	private func sekvaNodo(el nodo: NSManagedObject, kun litero: String) -> NSManagedObject? {
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
	
	/// Kreas destinon, kiu kondukos el nodo al artikolo, kaj skribas ĝin en kontekston
	func fariDestinon(
		el serchebla: Serchebla,
		por nodo: NSManagedObject,
		en konteksto: NSManagedObjectContext
	) {
		guard let artikolo = Datumbaza.artikolo(porIndekso: serchebla.indekso) else {
			assert(false, "Ne trovis artikolon '\(serchebla.indekso)'")
		}
		
		let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
		novaDestino.setValue(serchebla.videblaTeksto, forKey: "teksto")
		novaDestino.setValue(serchebla.indekso, forKey: "indekso")
		novaDestino.setValue(serchebla.subteksto, forKey: "nomo")
		novaDestino.setValue(serchebla.derivajhMarko, forKey: "marko")
		serchebla.senco.flatMap { novaDestino.setValue(String($0), forKey: "senco") }
		novaDestino.setValue(artikolo, forKey: "artikolo")
		nodo.mutableOrderedSetValue(forKey: "destinoj").add(novaDestino)
	}
}

