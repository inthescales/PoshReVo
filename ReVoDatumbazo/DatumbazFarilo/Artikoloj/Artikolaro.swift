import Foundation
import CoreData

/// Enkapsuligas ĉiujn funkciojn pri legado kaj traktado de artikoloj
enum Artikolaro {
	/// Rezulto de legado kaj traktado de ĉiuj artikoloj
	struct Rezulto {
		var artikoloj: [Artikolo]
		var tradukoj: [String: [SerchTraduko]]
		var serchVortoj: [SerchVorto]
		var fakVortoj: [String: [FakVorto]]
		var ofcVortoj: [String: [OfcVorto]]
		
		init(
			artikoloj: [Artikolo],
			tradukoj: [String: [SerchTraduko]],
			serchVortoj: [SerchVorto],
			fakVortoj: [String: [FakVorto]],
			ofcVortoj: [String: [OfcVorto]]
		) {
			self.artikoloj = artikoloj
			self.tradukoj = tradukoj
			self.fakVortoj = fakVortoj
			self.serchVortoj = serchVortoj
			self.ofcVortoj = ofcVortoj
		}
	}
	
	/// Rezulto de skribado de artikoloj al datumbazo
	struct SkribRezulto {
		/// Artikolaj datumbaz-objektoj, por ke ne endu reserĉi ilin poste
		let artikoloj: [String: NSManagedObject]
	}
	
	/// Legas ĉiujn artikolojn el certa indikilo kaj liveras ĉiujn artikolo-modelojn kaj serĉ-tradukojn
	static func legi(el indikilo: String, grundo: Grundo) -> Rezulto {
		legi(
			el: indikilo,
			lingvoDict: grundo.lingvoDict,
			stiloDict: grundo.stiloDict,
			signoj: grundo.signoj,
			mallongigoj: grundo.mallongigojVerkaj,
			urloj: grundo.urloj
		)
	}
	
	/// Legas ĉiujn artikolojn el certa indikilo kaj liveras ĉiujn artikolo-modelojn kaj serĉ-tradukojn
	static func legi(
		el indikilo: String,
		lingvoDict: [String: Lingvo],
		stiloDict: [String: String],
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) -> Rezulto {
		// let legotaj = ["not.xml"]
		let legotaj = try! FileManager.default.contentsOfDirectory(atPath: indikilo)
			.filter { $0.hasSuffix(".xml") }
		
		// Legi artikolojn

		var artikoloj: [Artikolo] = []
		var tradukoj: [String: [SerchTraduko]] = [:]
		var serchVortoj: [SerchVorto] = []
		var fakVortoj: [String: [FakVorto]] = [:]
		var ofcVortoj: [String: [OfcVorto]] = [:]
		var markSencoj: [String: Int] = [:]

		for indiko in legotaj {
			let rezulto = ArtikolAnalizilo.legi(
				el: indikilo + "/" + indiko,
				lingvoDict: lingvoDict,
				stiloDict: stiloDict,
				signoj: signoj,
				mallongigoj: mallongigoj,
				urloj: urloj
			)
			
			artikoloj.append(rezulto.artikolo)
			
			// Serchtradukoj
			tradukoj.merge(rezulto.serchTradukoj) { malnovaj, novaj in
				malnovaj + novaj
			}
			
			// Serchvortoj
			serchVortoj += rezulto.serchVortoj
			
			// Fakvortoj
			fakVortoj.merge(rezulto.fakVortoj) { malnovaj, novaj in
				malnovaj + novaj
			}
			
			// Fakvortoj
			ofcVortoj.merge(rezulto.ofcVortoj) { malnovaj, novaj in
				malnovaj + novaj
			}
			
			// Marksencoj
			rezulto.markSencoj.forEach { marko, senco in
				markSencoj[marko] = senco
			}
			
			print("Legis \(rezulto.artikolo.titolo)")
		}

		// Posttrakti artikolojn

		artikoloj = artikoloj.map { artikolo in
			return Posttraktado.postTrakti(artikolon: artikolo, markSencoj: markSencoj)
		}
		
		return Rezulto(
			artikoloj: artikoloj,
			tradukoj: tradukoj,
			serchVortoj: serchVortoj,
			fakVortoj: fakVortoj,
			ofcVortoj: ofcVortoj
		)
	}
	
	/// Registras artikolojn en datumbaz-kontekston
	public static func skribi(
		artikolojn artikoloj: [Artikolo],
		en konteksto: NSManagedObjectContext
	) -> SkribRezulto {
		var objektoj: [String: NSManagedObject] = [:]
		for (indekso, artikolo) in artikoloj.enumerated() {
			let novaObjekto = artikolo.skribi(en: konteksto, numero: indekso)
			objektoj[artikolo.indekso] = novaObjekto
		}
		
		try! konteksto.save()
		
		return SkribRezulto(artikoloj: objektoj)
	}
}
