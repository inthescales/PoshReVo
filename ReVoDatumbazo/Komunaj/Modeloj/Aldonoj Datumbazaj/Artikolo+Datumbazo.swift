import CoreData

extension Artikolo {
	func skribi(en konteksto: NSManagedObjectContext, numero: Int) -> NSManagedObject {
		let dbObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto)
		
		// Skribi ecojn
		
		dbObjekto.setValue(titolo, forKey: "titolo")
		dbObjekto.setValue(radiko, forKey: "radiko")
		dbObjekto.setValue(indekso, forKey: "indekso")
		dbObjekto.setValue(ofc, forKey: "ofc")
		dbObjekto.setValue(numero, forKey: "numero")
		
		// Skribi enhavojn

		let vortoJSON = try! JSONSerialization.data(
			withJSONObject: [subartikoloj],
			options: JSONSerialization.WritingOptions()
		)
		dbObjekto.setValue(vortoJSON, forKey: "vortoj")
		
		// Skribi tradukojn
		
		let tradukDict: [String: String] = tradukoj.reduce([:]) { dict, traduko in
			dict.merging([traduko.lingvo.kodo: traduko.teksto]) { malnovaj, novaj in
				malnovaj + novaj
			}
		}
		
		let tradukoJSON = try! JSONSerialization.data(
			withJSONObject: tradukDict,
			options: JSONSerialization.WritingOptions()
		)
		dbObjekto.setValue(tradukoJSON, forKey: "tradukoj")
		
		try! konteksto.save()
		
		return dbObjekto
	}
	
	static func el(
		_ objekto: NSManagedObject,
		alirilo: DatumbazAlirilo
	) -> Artikolo? {
		guard let titolo = objekto.value(forKey: "titolo") as? String,
			  let radiko = objekto.value(forKey: "radiko") as? String,
			  let indekso = objekto.value(forKey: "indekso") as? String,
			  let vortoDatumoj = objekto.value(forKey: "vortoj") as? Data,
			  let tradukDatumoj = objekto.value(forKey: "tradukoj") as? Data else {
			return nil
		}
		
		let oficialeco = objekto.value(forKey: "ofc") as? String
		
		let subartikoloj = try! JSONDecoder().decode([Subartikolo].self, from: vortoDatumoj)

		let tradukoDict = try! JSONDecoder().decode([String: String].self, from: tradukDatumoj)
		let tradukoj = tradukoDict.map { kodo, teksto in
			let lingvObjekto = alirilo.lingvo(porKodo: kodo)!
			let lingvo = Lingvo.el(lingvObjekto)!
			return Traduko(lingvo: lingvo, teksto: teksto)
		}

		return Artikolo(
			titolo: titolo,
			radiko: radiko,
			indekso: indekso,
			ofc: oficialeco,
			subartikoloj: subartikoloj,
			tradukoj: tradukoj
		)
	}
}
