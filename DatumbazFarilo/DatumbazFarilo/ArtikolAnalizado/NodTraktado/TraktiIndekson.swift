extension ArboAnalizilo {
	static func trakti(indekson indekso: ArtikolNodo, stato: TraktadoStato) -> (teksto: String, serchTeksto: String) {
		var teksto = ""
		var filaMLLTeksto: String? = nil
		
		traktiFilojn(de: indekso, stato: stato) { filo in
			
			switch filo.tipo {
			case .mll(let tipo):
				let filTeksto = trakti(mallongigon: filo, stato: stato)
				teksto += filTeksto
				// Ideale la '…' kiun aldonas ĉi-funkcio estus videbla en serĉrezultoj, sed ne
				// estus parto de serĉ-nomo. Tamen tio ne gravas.
				filaMLLTeksto = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
			default:
				let filTeksto = trakti(nodon: filo, stato: stato)
				teksto += filTeksto ?? ""
			}
		}
		
		return (teksto, filaMLLTeksto ?? teksto)
	}
}
