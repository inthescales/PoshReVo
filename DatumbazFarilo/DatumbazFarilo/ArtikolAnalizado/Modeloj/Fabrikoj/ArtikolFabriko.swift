import ReVoModelojOSX

/// Fabriko fabrikanta artikolojn
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
			let teksto = ArtikolTeksto.tradukTeksto(por: trdoj)
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
			assert(false, "Eraro okazis en artikol-legado")
			return nil
		}
	}
}
