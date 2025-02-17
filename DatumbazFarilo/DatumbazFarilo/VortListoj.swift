import CoreData

import ReVoDatumbazoOSX

enum VortListoj {
	static func skribi(
		fakVortojn fakVortoj: [String: [FakVorto]],
		artikolObjektoj: [String: NSManagedObject]? = nil,
		en konteksto: NSManagedObjectContext
	) {
		// TODO: Movi al ReVoDatumbazo? Eble movinta FakVorto-n en ReVoModeloj-n
		
		for (fako, vortoListo) in fakVortoj {
			print("Skribas fakon \(fako)")
			let fako = Datumbaza.fako(porKodo: fako, en: konteksto)!
			
			for fakVorto in vortoListo {
				let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
				novaDestino.setValue(fakVorto.teksto, forKey: "nomo")
				novaDestino.setValue(fakVorto.teksto, forKey: "teksto")
				novaDestino.setValue(fakVorto.indekso, forKey: "indekso")
				novaDestino.setValue(fakVorto.marko, forKey: "marko")
				fakVorto.senco.flatMap { novaDestino.setValue(String($0), forKey: "senco") }
				
				if let artikolo = artikolObjektoj?[fakVorto.indekso]
						?? Datumbaza.artikolo(porIndekso: fakVorto.indekso, en: konteksto) {
					novaDestino.setValue(artikolo, forKey: "artikolo")
					fako.mutableSetValue(forKey: "fakvortoj").add(novaDestino)
				}
			}
		}
		
		try! konteksto.save()
	}
	
	static func skribi(
		ofcVortojn ofcVortoj: [String: [OfcVorto]],
		artikolObjektoj: [String: NSManagedObject]? = nil,
		en konteksto: NSManagedObjectContext
	) {
		// TODO: Movi al ReVoDatumbazo? Eble movinta OfcVorto-n en ReVoModeloj-n
		
		for (ofc, vortoListo) in ofcVortoj {
			print("Skribas oficialecon \(ofc)")
			let oficialeco = Datumbaza.oficialeco(porKodo: ofc, en: konteksto)!
			
			for ofcVorto in vortoListo {
				
				let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
				novaDestino.setValue(ofcVorto.teksto, forKey: "nomo")
				novaDestino.setValue(ofcVorto.teksto, forKey: "teksto")
				novaDestino.setValue(ofcVorto.indekso, forKey: "indekso")
				
				if let artikolo = artikolObjektoj?[ofcVorto.indekso]
					?? Datumbaza.artikolo(porIndekso: ofcVorto.indekso, en: konteksto) {
					novaDestino.setValue(artikolo, forKey: "artikolo")
					oficialeco.mutableSetValue(forKey: "ofcvortoj").add(novaDestino)
				}
			}
		}
		
		try! konteksto.save()
	}
}
