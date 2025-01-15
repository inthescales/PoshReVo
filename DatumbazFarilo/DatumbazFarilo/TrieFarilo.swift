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
		
        guard let lingvoObjekto = lingvo(porKodo: kodo),
			  let tradukoj = tradukaro[kodo] else {
			  return
		  }
        
        do {
			var nunNodo: NSManagedObject? = nil
			for traduko in tradukoj {
				// Kiel dict: indekso, senco, teksto, marko
				
				let videbla = traduko.videblaNomo
				let teksto = traduko.teksto
				let nomo = traduko.nomo
				let indekso = traduko.indekso
				let marko = traduko.marko
				let senco = traduko.senco
				
				// Trovi klavojn
				var klavoj = [String]()
				klavoj.append(teksto)
				if videbla != teksto { klavoj.append(videbla) }
				
				for klavo in klavoj {
					for nunLitero in klavo.lowercased() {
						
						var sekvaNodo: NSManagedObject? = nil
						if nunNodo == nil {
							if let trovNodo = akiriKomencanNodon(el: lingvoObjekto, kunLitero: String(nunLitero)) {
								sekvaNodo = trovNodo
							}
						} else {
							if let trovNodo = akiriSekvanNodon(el: nunNodo!, kunLitero: String(nunLitero)) {
								sekvaNodo = trovNodo
							}
						}
						
						if sekvaNodo == nil {
							sekvaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
							sekvaNodo?.setValue(String(nunLitero), forKey: "litero")
							
							if nunNodo == nil {
								lingvoObjekto.mutableSetValue(forKey: "komencajNodoj").add(sekvaNodo!)
							} else {
								nunNodo?.mutableSetValue(forKey: "sekvajNodoj").add(sekvaNodo!)
							}
						}
						
						nunNodo = sekvaNodo
						
					}
					
					// if indekso != nil {
						let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
						novaDestino.setValue(videbla, forKey: "teksto")
						novaDestino.setValue(indekso, forKey: "indekso")
						novaDestino.setValue(nomo, forKey: "nomo")
						novaDestino.setValue(marko, forKey: "marko")
						if let senco = senco {
							novaDestino.setValue(String(senco), forKey: "senco")
						}
						if let artikolo = artikolo(porIndekso: indekso) {
							novaDestino.setValue(artikolo, forKey: "artikolo")
						}
						nunNodo?.mutableOrderedSetValue(forKey: "destinoj").add(novaDestino)
					// }
					
					nunNodo = nil
				} // Serch klavoj
			} // Chiu traduko
			
			try! konteksto.save()
		}
    }
	
	// MARK: - Helpiloj
	
	/// Liveras NSManagedObject-on reprezentantan lingvon havantan la donatan kodon
	private func lingvo(porKodo kodo: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
	
	/// Liveras ĉiuj komencajn trie-nodojn de certa lingva NSManagedObject
	func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
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
	
	/// Liveras artikolan NSManagedObject-on havantan certan indekson.
	func artikolo(porIndekso indekso: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])

		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
}

