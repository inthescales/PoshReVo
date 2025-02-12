import Foundation
import CoreData

import ReVoModelojOSX

/// Enkapsuligas ĉiujn funkciojn pri legado kaj traktado de artikoloj
enum Artikolaro {
	/// Rezulto de legado kaj traktado de ĉiuj artikoloj
	struct Rezulto {
		var artikoloj: [Artikolo]
		var tradukoj: [String: [SerchTraduko]]
		
		init(artikoloj: [Artikolo], tradukoj: [String: [SerchTraduko]]) {
			self.artikoloj = artikoloj
			self.tradukoj = tradukoj
		}
	}
	
	/// Legas ĉiujn artikolojn el certa indikilo kaj liveras ĉiujn artikolo-modelojn kaj serĉ-tradukojn
	static func legi(el indikilo: String, grundo: Grundo) -> Rezulto {
		legi(
			el: indikilo,
			lingvoDict: grundo.lingvoDict,
			stiloDict: grundo.stiloDict,
			signoj: grundo.signoj,
			mallongigoj: grundo.mallongigojVerkaj,
			urloj: grundo.urloj)
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
		let legotaj = ["mojos.xml"]
//		let legotaj = try! FileManager.default.contentsOfDirectory(atPath: indikilo)
//			.filter { $0.hasSuffix(".xml") }
		
		// Legi artikolojn

		var artikoloj: [Artikolo] = []
		var tradukoj: [String: [SerchTraduko]] = [:]
		var markSencoj: [String: Int] = [:]

		for indiko in legotaj {
			guard let arbo = ArtikolKonvertilo.konverti(
				el: indikilo + indiko,
				signoj: signoj,
				mallongigoj: mallongigoj,
				urloj: urloj
			) else {
				print("NE sukcesis konverti artikolon '\(indiko)'")
				continue
			}
			
			let dosierNomo = String(indiko.split(separator: "/").last!)
			let indekso = dosierNomo.prefikso(ghis: dosierNomo.count - 4)
			
			guard let rezulto = ArboAnalizilo.analizi(
				arbon: arbo,
				indekso: indekso,
				lingvoj: lingvoDict,
				stiloj: stiloDict
			) else {
				print("NE sukcesis analizi artikolon '\(indiko)'")
				continue
			}
			
			artikoloj.append(rezulto.artikolo)
			print("Analizis '\(rezulto.artikolo.titolo)'")
			
			for (lingvo, novajTradukoj) in rezulto.serchTradukoj {
				if tradukoj[lingvo] == nil {
					tradukoj[lingvo] = []
				}
				
				tradukoj[lingvo]? += novajTradukoj
			}
			
			rezulto.markSencoj.forEach { marko, senco in
				markSencoj[marko] = senco
			}
		}

		// Posttrakti artikolojn

		artikoloj = artikoloj.map { artikolo in
			return postTrakti(artikolon: artikolo, markSencoj: markSencoj)
		}
		
		return Rezulto(
			artikoloj: artikoloj,
			tradukoj: tradukoj
		)
	}
	
	/// Registras artikolojn en datumbaz-kontekston
	public static func skribi(
		artikolojn artikoloj: [Artikolo],
		en konteksto: NSManagedObjectContext
	) {
		for (indekso, artikolo) in artikoloj.enumerated() {
			artikolo.skribi(en: konteksto, numero: indekso)
		}
		
		try! konteksto.save()
	}
}
