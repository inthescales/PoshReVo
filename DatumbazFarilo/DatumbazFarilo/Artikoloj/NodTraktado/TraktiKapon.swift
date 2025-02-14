extension ArboAnalizilo {
	struct KapRezulto {
		/// Tuta teksto, kiel ĝi aperu en artikolo
		let teksto: String
		
		/// Teksto kun tildoj, kiel ĝi aperu en artikol-tradukoj
		let tildTeksto: String
		
		/// Ĉiuj variaĵoj de la kapvorto, el kiuj ĉiuj estu serĉeblaj
		let formoj: [String]
	}
	
	static func trakti(kapon kapo: ArtikolNodo, stato: Stato) -> KapRezulto {
		var teksto = ""
		var tildTeksto = ""
		
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
				case .rad(let vari):
					let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
					teksto += filTeksto
					tildTeksto += "~"
				case .teksto(let filTeksto):
					teksto += filTeksto.prepari().kunpremi()
					tildTeksto += filTeksto.prepari().kunpremi()
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .vari:
					let filRezulto = trakti(variajhon: filo, stato: stato)
					teksto += filRezulto.nomo
				default:
					assert(false, "Neatendita filo")
				}
			}
			
			teksto = teksto.tondi()
			stato.artikolFabriko.titolo = teksto
			
			// Krei ofcvortojn
			let ofc = ArtikolTeksto.konservOficialeco(ofc: stato.artikolFabriko.ofc)
			if let artikolIndekso = stato.artikolIndekso {
				let ofcVorto = OfcVorto(
					teksto: teksto,
					indekso: artikolIndekso
				)
				stato.aldoni(ofcVorton: ofcVorto, oficialeco: ofc)
			}
			
			return KapRezulto(
				teksto: teksto,
				tildTeksto: tildTeksto,
				formoj: ArtikolTeksto.kapFormoj(por: teksto)
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
				formoj: ArtikolTeksto.kapFormoj(por: teksto)
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
				formoj: ArtikolTeksto.kapFormoj(por: teksto)
			)
		default:
			assert(false, "Neatendita cheno")
			return KapRezulto(teksto: "", tildTeksto: "", formoj: [])
		}
	}
}
