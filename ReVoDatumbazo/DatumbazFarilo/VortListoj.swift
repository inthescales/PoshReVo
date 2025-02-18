import CoreData

import ReVoDatumbazoOSX

enum VortListoj {
	static func skribi(
		fakVortojn fakVortoj: [String: [FakVorto]],
		artikolObjektoj: [String: NSManagedObject]? = nil,
		en konteksto: NSManagedObjectContext
	) {
		let alirilo = DatumbazAlirilo(konteksto: konteksto)
		for (fako, vortoListo) in fakVortoj {
			print("Skribas fakon \(fako)")
			let fako = alirilo.fako(porKodo: fako)!
			
			for fakVorto in vortoListo {
				let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
				novaDestino.setValue(fakVorto.teksto, forKey: "teksto")
				novaDestino.setValue(fakVorto.marko, forKey: "marko")
				fakVorto.senco.flatMap { novaDestino.setValue(String($0), forKey: "senco") }
				
				if let artikolo = artikolObjektoj?[fakVorto.indekso]
						?? alirilo.artikolo(porIndekso: fakVorto.indekso) {
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
		let alirilo = DatumbazAlirilo(konteksto: konteksto)
		for (ofc, vortoListo) in ofcVortoj {
			print("Skribas oficialecon \(ofc)")
			let oficialeco = alirilo.oficialeco(porKodo: ofc)!
			
			for ofcVorto in vortoListo {
				
				let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
				novaDestino.setValue(ofcVorto.teksto, forKey: "teksto")
				
				if let artikolo = artikolObjektoj?[ofcVorto.indekso]
					?? alirilo.artikolo(porIndekso: ofcVorto.indekso) {
					novaDestino.setValue(artikolo, forKey: "artikolo")
					oficialeco.mutableSetValue(forKey: "ofcvortoj").add(novaDestino)
				}
			}
		}
		
		try! konteksto.save()
	}
}
