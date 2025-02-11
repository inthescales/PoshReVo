extension ArboAnalizilo {
	struct IndeksRezulto {
		/// Teksto de la <ind> en sia plena formo (<tld/> fariĝas kapvorton)
		let teksto: String
		
		/// Teksto de la <ind> en tildhava formo (<tld/> restas `~`)
		let tildTeksto: String
		
		/// Teksto kiel ĝi aperu en serĉrezultoj (povas enhavi `…`, ekz.)
		let serchTeksto: String
	}
	
	static func trakti(indekson indekso: ArtikolNodo, stato: TraktadoStato) -> IndeksRezulto {
		var teksto = ""
		var tildTeksto = ""
		var serchTeksto: String? = nil
		
		traktiFilojn(de: indekso, stato: stato) { filo in
			switch filo.tipo {
			case .klr:
				if serchTeksto == nil {
					serchTeksto = teksto
				}
				
				let filTeksto = trakti(klarigon: filo, stato: stato)
				teksto += filTeksto
				tildTeksto += filTeksto
			case .mll(let tipo):
				let filTeksto = trakti(mallongigon: filo, stato: stato)
				// teksto += filTeksto
				// tildTeksto += filTeksto
				teksto = filTeksto
				tildTeksto = filTeksto
				
				// Ideale la '…' kiun aldonas ĉi-funkcio estus videbla en serĉrezultoj, sed ne
				// estus parto de serĉ-nomo.
				// TODO: Certigu ke '…' estu ignorata konstruante trie-on
				serchTeksto = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
			case .teksto(let filTeksto):
				teksto += filTeksto
				tildTeksto += filTeksto
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
				tildTeksto += "~"
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return IndeksRezulto(
			teksto: teksto,
			tildTeksto: tildTeksto,
			serchTeksto: serchTeksto ?? teksto
		)
	}
}
