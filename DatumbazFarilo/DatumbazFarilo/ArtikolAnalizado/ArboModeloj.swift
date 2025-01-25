import Foundation
import ReVoModelojOSX

struct ArtikolAnalizRezulto {
	let artikolo: Artikolo
	let serchTradukoj: [String: [SerchTraduko]]
	let markSencoj: [String: Int]
}

/// Traduko tiel kiel ĝi aperos en artikolo
struct ArtikolTraduko {
	let nomo: String
	let teksto: String
	let marko: String
	let senco: Int?
}

/// Traduko kiu estos serĉebla
struct SerchTraduko {
	let videblaNomo: String // Search key, and what is shown
	let nomo: String // Detail label of search cell (esperanto derivaĵo)
	let teksto: String // Search key (name in search language)
	let indekso: String // Used to create the article reference
	let marko: String // Used to navigate within article
	let senco: Int? // Creates superscript
}

struct SubartikoloFabriko {
	var teksto = ""
	var vortoj: [Vorto] = []
	
	func fabriki() -> Subartikolo? {
		return Subartikolo(
			teksto: teksto,
			vortoj: vortoj
		)
	}
}

struct VortoFabriko {
	var titolo: String?
	var teksto: String?
	var marko: String?
	var ofc: String?
	
	func fabriki() -> Vorto? {
		if let titolo = titolo,
		   let teksto = teksto {
			return Vorto(
				titolo: titolo,
				teksto: teksto,
				marko: marko,
				ofc: ofc
			)
		}
		
		return nil
	}
}

struct ArtikolFabriko {
	var titolo: String?
	var radiko: String?
	var indekso: String?
	var ofc: String?
	var subartikoloj: [Subartikolo] = []
	var tradukoj: [String: [ArtikolTraduko]] = [:]
	
	func fabriki(lingvoj: [String: Lingvo]) -> Artikolo? {
		var tekstTradukoj: [Traduko] = []
		
		for (lingvoKodo, trdoj) in tradukoj {
			let teksto = prepariTradukTekstojn(tradukoj: trdoj)
			let trd = Traduko(
				lingvo: lingvoj[lingvoKodo]!,
				teksto: teksto
			)
			tekstTradukoj.append(trd)
		}
		
		if let titolo = titolo,
		   let radiko = radiko,
		   let indekso = indekso,
		   !subartikoloj.isEmpty {
			return Artikolo(
				titolo: titolo,
				radiko: radiko,
				indekso: indekso,
				ofc: ofc,
				subartikoloj: subartikoloj,
				tradukoj: tekstTradukoj
			)
		} else {
			assert(false, "Ia eraro okazis en artikol-legado")
		}
	}
}

class Stato {
	init(stiloj: [String: String]) {
		self.stiloj = stiloj
	}
	
	var artikolFabriko = ArtikolFabriko()
	var subartikoloFabriko: SubartikoloFabriko?
	var vortoFabriko: VortoFabriko?
	
	// MARK: Grundaĵoj
	
	let stiloj: [String: String]
	
	// MARK: Artikol-informoj
	
	var artikolRadiko: String? {
		artikolFabriko.radiko
	}
	
	var artikolRadikVariajhoj: [String: String] = [:]
	
	var artikolNomo: String? {
		artikolFabriko.titolo
	}
	
	var artikolIndekso: String? {
		artikolFabriko.indekso
	}
	
	// MARK: Arbo-tradirada stato
	
	/// Stako enhavanta la nod-tipojn de la ĉi-nodaj patroj
	var cheno: [NodTipo] = []
	
	/// Stako enhavanta la nod-tipojn de la lastaj siboj
	var sibStako: [NodTipo?] = []
	
	/// Titolo de nuna derivaĵo, plenteksta, kiel ĝi aperu en serĉrezultoj
	var derivajhNomo: String?
	
	/// Titolo de nuna derivaĵo, kun ~-oj, kiel ĝi aperu en tradukoj
	var derivajhTildo: String?
	
	/// Numero de la lasta senco traktita en la derivaĵo (eĉ si la procezo jam eliris el ĉiuj sencoj)
	/// Necesas por nombri la sencojn (endas scii la lastan senc-numeron).
	var lastaSenco: Int?
	
	/// Numero de la *nuna* senco en sia derivaĵo. Havas valoron nur se la procezo estas nun ene de iu senco.
	/// Necesas por ke ni sciu ĉu la procezo ankoraŭ estas ene de senco, aŭ ĉu ĝi jam eliras (ekz. kiam ni renkontas tradukon post ĉiuj sencoj en derivaĵo)
	var nunaSenco: Int?
	
	/// Samkiel `lastaSenco` je subsencoj
	var lastaSubsenco: Int?

	/// Samkiel `nunaSenco` je subsencoj
	var nunaSubsenco: Int?
	
	var marko: String? {
		for tipo in cheno.reversed() {
			switch tipo {
			case .art(let mrk):
				return mrk
			case .drv(let mrk):
				return mrk
			default:
				continue
			}
		}
		
		return nil
	}
	
	/// Por ĉiu marko kiu aperas en senco, la numero de tiu senco (por resolvi 'sncref'-ojn)
	var markSencoj: [String: Int] = [:]
	
	// MARK: Tradukoj
	
	var serchTradukoj: [String: [SerchTraduko]] = [:]
	
	func aldoni(artikolTradukon traduko: ArtikolTraduko, lingvo: String) {
		if artikolFabriko.tradukoj[lingvo] == nil { artikolFabriko.tradukoj[lingvo] = [] }
		artikolFabriko.tradukoj[lingvo]?.append(traduko)
	}
	
	func aldoni(serchTradukon traduko: SerchTraduko, lingvo: String) {
		if serchTradukoj[lingvo] == nil { serchTradukoj[lingvo] = [] }
		serchTradukoj[lingvo]?.append(traduko)
	}
	
	// MARK: Rezultoj
	
	func rezultoj(lingvoj: [String: Lingvo]) -> ArtikolAnalizRezulto? {
		guard let artikolo = artikolFabriko.fabriki(lingvoj: lingvoj) else {
			return nil
		}
		
		return ArtikolAnalizRezulto(
			artikolo: artikolo,
			serchTradukoj: serchTradukoj,
			markSencoj: markSencoj
		)

	}
}
