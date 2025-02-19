//
//  Artikolo+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

extension Artikolo {
	func skribi(en konteksto: NSManagedObjectContext, numero: Int) -> NSManagedObject {
		let dbObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto)
		
		// Skribi ecojn
		
		dbObjekto.setValue(titolo, forKey: "titolo")
		dbObjekto.setValue(radiko, forKey: "radiko")
		dbObjekto.setValue(indekso, forKey: "indekso")
		dbObjekto.setValue(ofc, forKey: "ofc")
		
		// Skribi enhavojn
		
		var subartArr = [[String: Any]]()
		for subartikolo in subartikoloj {
			var novaSubart = [String: Any]()
			novaSubart["teksto"] = subartikolo.teksto
			
			var vortArr = [[String: Any]]()
			for vorto in subartikolo.vortoj {
				var novaVorto = [String: Any]()
				novaVorto["titolo"] = vorto.titolo
				novaVorto["teksto"] = vorto.teksto
				novaVorto["marko"] = vorto.marko
				novaVorto["ofc"] = vorto.ofc
				vortArr.append(novaVorto)
			}
			novaSubart["vortoj"] = vortArr
			
			subartArr.append(novaSubart)
		}
		
		do {
			let vortoJSON = try JSONSerialization.data(withJSONObject: subartArr, options: JSONSerialization.WritingOptions())
			dbObjekto.setValue(vortoJSON, forKey: "vortoj")
		} catch {
			print("Eraro skribante enhavojn de artikolo '" + titolo + "'")
		}
		
		// Skribi tradukojn
		
		var tradukArr = [String: Any?]()
		for traduko in tradukoj {
			tradukArr[traduko.lingvo.kodo] = traduko.teksto
		}
		
		do {
			let tradukoJSON = try JSONSerialization.data(withJSONObject: tradukArr, options: JSONSerialization.WritingOptions())
			dbObjekto.setValue(tradukoJSON, forKey: "tradukoj")
		} catch {
			print("Eraro skribante enhavojn de artikolo '\(titolo)'")
		}
		
		dbObjekto.setValue(numero, forKey: "numero")
		
		do {
			try konteksto.save()
		} catch {
			print("Eraro konservante kontekston por artikolo '\(titolo)'")
		}
		
		return dbObjekto
	}
	
	static func elDatumbazObjekto(
		objekto: NSManagedObject,
		alirilo: DatumbazAlirilo
	) -> Artikolo? {
        guard let trovTitolo = objekto.value(forKey: "titolo") as? String,
            let trovRadiko = objekto.value(forKey: "radiko") as? String,
            let trovIndekso = objekto.value(forKey: "indekso") as? String else {
           return nil
        }
		
		let trovOfc = objekto.value(forKey: "ofc") as? String
		
        var novajSubartikoloj: [Subartikolo]? = [Subartikolo]()
        var novajTradukoj: [Traduko] = [Traduko]()
        do {
           
           if let vortoDatumoj = objekto.value(forKey: "vortoj") as? NSData {
               let vortoJ = try JSONSerialization.jsonObject(with: vortoDatumoj as Data, options: JSONSerialization.ReadingOptions())
			   
			   if let subartArr = vortoJ as? [[String: Any]] {
                   for subartikoloj in subartArr {
                       var novajVortoj = [Vorto]()
                       for vorto in (subartikoloj["vortoj"] as? [[String: Any]]) ?? [[:]] {
                           if let titolo = vorto["titolo"] as? String,
                              let teksto = vorto["teksto"] as? String,
                              let marko = vorto["marko"] as? String {
                                novajVortoj.append(
                                    Vorto(titolo: titolo,
                                          teksto: teksto,
                                          marko: marko,
                                          ofc: vorto["ofc"] as? String
                                    )
                                )
                           }
                       }
                       
                       let teksto = (subartikoloj["teksto"] as? String) ?? ""
                       novajSubartikoloj?.append(Subartikolo(teksto: teksto, vortoj:novajVortoj ))
                   }
               }
           }
           
           // Prepari la tradukojn
			if let tradukDatumoj = objekto.value(forKey: "tradukoj") as? NSData {
				let tradukJSON = try JSONSerialization.jsonObject(with: tradukDatumoj as Data, options: JSONSerialization.ReadingOptions())
				if let tradukDict = tradukJSON as? [String: String] {
					for (lingvoKodo, teksto) in tradukDict {
						if let lingvObjekto = alirilo.lingvo(porKodo: lingvoKodo),
						   let lingvo = Lingvo.el(lingvObjekto) {
							let novaTraduko = Traduko(lingvo: lingvo, teksto: teksto)
							novajTradukoj.append(novaTraduko)
						}
					}
				}
			}
        } catch {
           return Artikolo(titolo: trovTitolo,
                           radiko: trovRadiko,
                           indekso: trovIndekso,
                           ofc: nil,
                           subartikoloj: [],
                           tradukoj: [])
        }

        return Artikolo(titolo: trovTitolo,
                        radiko: trovRadiko,
                        indekso: trovIndekso,
                        ofc: trovOfc,
                        subartikoloj: novajSubartikoloj ?? [],
                        tradukoj: novajTradukoj)
       
   }
}
