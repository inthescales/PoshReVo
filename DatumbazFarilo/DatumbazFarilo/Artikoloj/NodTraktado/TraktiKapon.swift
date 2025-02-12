extension ArboAnalizilo {
	struct KapRezulto {
		/// Tuta teksto, kiel ĝi aperu en artikolo
		let teksto: String
		
		/// Teksto kun tildoj, kiel ĝi aperu en artikol-tradukoj
		let tildTeksto: String
		
		/// Ĉiuj variaĵoj de la kapvorto, el kiuj ĉiuj estu serĉeblaj
		let formoj: [String]
	}
	
	static func trakti(kapon kapo: ArtikolNodo, stato: TraktadoStato) -> KapRezulto {
		var teksto = ""
		var tildTeksto = ""
		var formoj: [String] = []
		
		switch stato.cheno.last {
		case .art:
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .fnt:
					teksto = teksto.tondi()
					tildTeksto = tildTeksto.tondi()
					break
				case .ofc:
					stato.artikolFabriko.ofc = trakti(oficialecon: filo, stato: stato)
					// TODO: Aldoni ofc-vortojn
				case .rad(let vari):
					let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
					teksto += filTeksto
					tildTeksto += "~"
					formoj.append(filTeksto)
				case .teksto(let filTeksto):
					teksto += filTeksto.prepari().kunpremi()
					tildTeksto += filTeksto.prepari().kunpremi()
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .vari:
					let filRezulto = trakti(variajhon: filo, stato: stato)
					teksto += filRezulto.nomo
					formoj.append(filRezulto.nomo)
				default:
					assert(false, "Neatendita filo")
				}
			}
			
			teksto = teksto.tondi()
			stato.artikolFabriko.titolo = teksto
			
			return KapRezulto(
				teksto: teksto,
				tildTeksto: tildTeksto,
				formoj: teksto.split(separator: ", ").map { String($0) }
			)
		case .drv:
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .fnt:
					break
				case .ofc:
					stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
				case .teksto(let filTeksto):
					teksto += filTeksto.prepari().kunpremi()
					tildTeksto += filTeksto
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .vari:
					let filRezulto = trakti(variajhon: filo, stato: stato)
					teksto += filRezulto.nomo
					tildTeksto += filRezulto.tildo
				default:
					assert(false, "Neatendita filo")
				}
			}
			stato.vortoFabriko?.titolo = teksto.tondi()
			stato.derivajhNomo = teksto.tondi()
			stato.derivajhTildo = tildTeksto.tondi()
			return KapRezulto(
				teksto: teksto,
				tildTeksto: tildTeksto,
				formoj: teksto.split(separator: ", ").map { String($0) }
			)
		case .vari:
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .fnt:
					teksto = teksto.tondi()
					tildTeksto = tildTeksto.tondi()
				case .ofc:
					if stato.vortoFabriko?.ofc == nil {
						stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
					}
				case .rad(let vari):
					let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
					teksto += filTeksto
					tildTeksto += "~"
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
			
			teksto = teksto.tondi()
			tildTeksto = tildTeksto.tondi()
			
			return KapRezulto(
				teksto: teksto,
				tildTeksto: tildTeksto,
				formoj: teksto.split(separator: ", ").map { String($0) }
			)
		default:
			assert(false, "Neatendita cheno")
			return KapRezulto(teksto: "", tildTeksto: "", formoj: [])
		}
	}
}
