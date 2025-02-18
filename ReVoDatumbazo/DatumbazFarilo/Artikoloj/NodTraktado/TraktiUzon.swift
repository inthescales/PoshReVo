extension ArboAnalizilo {
	static func trakti(uzon uzo: ArtikolNodo, tipo: String?, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: uzo, stato: stato)
		
		switch tipo {
		case "fak":
			// Krei fakvortojn
			if let artikolIndekso = stato.artikolIndekso,
			   let marko = stato.marko {
				for formo in stato.derivajhFormoj {
					let fakVorto = FakVorto(
						teksto: formo,
						indekso: artikolIndekso,
						marko: marko,
						senco: stato.nunaSenco
					)
					stato.aldoni(fakVorton: fakVorto, fako: teksto)
				}
			}
			
			return "[\(teksto)] "
		case "klr", "stl":
			let stilTeksto = stato.stiloj[teksto] ?? teksto
			return "(\(stilTeksto)) "
		case nil:
			return teksto
		default:
			assert(false, "Neatendita stilo")
			return ""
		}
	}
}
