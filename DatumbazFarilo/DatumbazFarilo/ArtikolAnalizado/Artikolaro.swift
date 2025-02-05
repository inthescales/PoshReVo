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
	
	/// Registras artikolojn en datumbaz-kontekston
	public static func registri(
		artikolojn artikoloj: [Artikolo],
		en konteksto: NSManagedObjectContext
	) {
		for (indekso, artikolo) in artikoloj.enumerated() {
			artikolo.skribi(en: konteksto, numero: indekso)
		}
		
		try! konteksto.save()
	}
	
	/// Legas ĉiujn artikolojn el certa indikilo kaj liveras ĉiujn artikolo-modelojn kaj serĉ-tradukojn
	static func legi(
		el indikilo: String,
		lingvoj: [Lingvo],
		stiloj: [Stilo],
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) -> Rezulto {
		// let legotaj = ["ni.xml"]
		let legotaj = try! FileManager.default.contentsOfDirectory(atPath: indikilo)

		// Prepari grundaĵojn
		
		let lingvoDict = lingvoj.reduce(into: [String: Lingvo]()) { dict, lingvo in
			dict[lingvo.kodo] = lingvo
		}

		let stiloDict = stiloj.reduce(into: [String: String]()) { dict, stilo in
			dict[stilo.kodo] = stilo.nomo
		}
		
		// Legi artikolojn

		var artikoloj: [Artikolo] = []
		var tradukoj: [String: [SerchTraduko]] = [:]
		var markSencoj: [String: Int] = [:]

		for indiko in legotaj {
			guard let rezulto = ArtikolAnalizilo.legi(
				el: revoIndiko + indiko,
				lingvoj: lingvoDict,
				stiloj: stiloDict,
				signoj: signoj,
				mallongigoj: verkajMallongigoj,
				urloj: urloj
			) else {
				print("NE atingis rezulton por artikolo '\(indiko)'")
				continue
			}
			
			artikoloj.append(rezulto.artikolo)
			print("Traktis '\(rezulto.artikolo.titolo)'")
			// print(rezulto.artikolo)
			
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
}
