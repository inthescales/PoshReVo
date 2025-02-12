extension ArboAnalizilo {
	struct IndeksRezulto {
		/// Teksto en sia plena formo, kiel ĝi aperu en artikol-tekstoj
		let teksto: String

		/// Teksto kiel ĝi aperu en serĉrezultoj (uzas mallongigojn)
		let serchTeksto: String
		
		/// Teksto kiel ĝi aperu en artikol-tradukoj (uzas `~`, mallongigojn)
		let tradukTeksto: String
	}
	
	static func trakti(indekson indekso: ArtikolNodo, stato: Stato) -> IndeksRezulto {
		var teksto = ""
		var tildTeksto = ""
		var serchTeksto: String?
		var tradukTeksto: String?
		
		traktiFilojn(de: indekso, stato: stato) { filo in
			switch filo.tipo {
			case .klr:
				if serchTeksto == nil { serchTeksto = teksto }
				if tradukTeksto == nil { tradukTeksto = teksto }
				
				let filTeksto = trakti(klarigon: filo, stato: stato)
				teksto += filTeksto
				tildTeksto += filTeksto
			case .mll(let tipo):
				let mllRezulto = trakti(mallongigon: filo, stato: stato)
				teksto += mllRezulto.teksto
				tildTeksto += mllRezulto.tildTeksto
				serchTeksto = ArtikolTeksto.mllTeksto(baza: mllRezulto.teksto, tipo: tipo)
				tradukTeksto = ArtikolTeksto.mllTeksto(baza: mllRezulto.tildTeksto, tipo: tipo)
			case .teksto(let filTeksto):
				let netaTeksto = filTeksto.prepari().kunpremi()
				teksto += netaTeksto
				tildTeksto += netaTeksto
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
				tildTeksto += "~"
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return IndeksRezulto(
			teksto: teksto,
			serchTeksto: serchTeksto ?? teksto,
			tradukTeksto: tradukTeksto ?? tildTeksto
		)
	}
}
