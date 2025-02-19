import CoreData

extension Artikolo {
	func skribi(en konteksto: NSManagedObjectContext, numero: Int) -> NSManagedObject {
		let dbObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto)
		
		dbObjekto.setValue(titolo, forKey: "titolo")
		dbObjekto.setValue(radiko, forKey: "radiko")
		dbObjekto.setValue(indekso, forKey: "indekso")
		dbObjekto.setValue(ofc, forKey: "ofc")
		dbObjekto.setValue(numero, forKey: "numero")
		
		let vortoJSON = try! JSONEncoder().encode(subartikoloj)
		dbObjekto.setValue(vortoJSON, forKey: "vortoj")
		
		let tradukoJSON = try! JSONEncoder().encode(tradukoj)
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
		let tradukoj = try! JSONDecoder().decode([Traduko].self, from: tradukDatumoj)

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
