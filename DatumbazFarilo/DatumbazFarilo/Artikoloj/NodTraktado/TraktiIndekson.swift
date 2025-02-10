extension ArboAnalizilo {
	static func trakti(indekson indekso: ArtikolNodo, stato: TraktadoStato) -> (teksto: String, serchTeksto: String) {
		var teksto = ""
		var serchTeksto: String? = nil
		
		traktiFilojn(de: indekso, stato: stato) { filo in
			
			switch filo.tipo {
			case .klr:
				if serchTeksto == nil {
					serchTeksto = teksto
				}
				
				teksto += trakti(klarigon: filo, stato: stato)
			case .mll(let tipo):
				let filTeksto = trakti(mallongigon: filo, stato: stato)
				teksto += filTeksto
				// Ideale la '…' kiun aldonas ĉi-funkcio estus videbla en serĉrezultoj, sed ne
				// estus parto de serĉ-nomo. Tamen tio ne gravas.
				serchTeksto = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
			case .teksto(let filTeksto):
				teksto += filTeksto
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return (teksto, serchTeksto ?? teksto)
	}
}
