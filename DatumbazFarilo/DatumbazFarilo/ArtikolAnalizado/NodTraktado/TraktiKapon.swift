extension ArboAnalizilo {
	static func trakti(kapon kapo: ArtikolNodo, stato: TraktadoStato) -> (nomo: String, tildo: String) {
		switch stato.cheno.last {
		case .art:
			var teksto = ""
			var tildTeksto = ""
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .rad(let vari):
					let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
					teksto += filTeksto
					tildTeksto += "~"
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .ofc:
					stato.artikolFabriko.ofc = trakti(oficialecon: filo, stato: stato)
					// TODO: Aldoni ofc-vortojn
				case .vari:
					let filRezulto = trakti(variajhon: filo, stato: stato)
					teksto += filRezulto.nomo
				case .teksto(let filTeksto):
					teksto += filTeksto.prepari().kunpremi()
					tildTeksto += filTeksto.prepari().kunpremi()
				case .fnt:
					teksto = teksto.tondi()
					tildTeksto = tildTeksto.tondi()
					break
				default:
					assert(false, "Neatendita filo")
				}
			}
			stato.artikolFabriko.titolo = teksto.tondi()
			return (teksto, tildTeksto)
		case .drv:
			var teksto = ""
			var tildTeksto = ""
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .ofc:
					stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
				case .vari:
					let filRezulto = trakti(variajhon: filo, stato: stato)
					teksto += filRezulto.nomo
					tildTeksto += filRezulto.tildo
				case .teksto(let filTeksto):
					teksto += filTeksto.prepari().kunpremi()
					tildTeksto += filTeksto
				case .fnt:
					break
				default:
					assert(false, "Neatendita filo")
				}
			}
			stato.vortoFabriko?.titolo = teksto.tondi()
			stato.derivajhNomo = teksto.tondi()
			stato.derivajhTildo = tildTeksto.tondi()
			return (teksto, tildTeksto)
		case .vari:
			var teksto = ""
			var tildTeksto = ""
			traktiFilojn(de: kapo, stato: stato) { filo in
				switch filo.tipo {
				case .tld(let lit, let vari):
					teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
					tildTeksto += "~"
				case .rad(let vari):
					let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
					teksto += filTeksto
					tildTeksto += "~"
				case .ofc:
					if stato.vortoFabriko?.ofc == nil {
						stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
					}
				case .teksto(let filTeksto):
					teksto += filTeksto
					tildTeksto += filTeksto
				case .fnt:
					teksto = teksto.tondi()
					tildTeksto = tildTeksto.tondi()
				default:
					assert(false, "Neatendita filo")
				}
			}
			// La kap-teksto tondiĝis, do ni aldonu kroman spacon
			//stato.vortoFabriko?.titolo? += " " + teksto.tondi()
			return (teksto.tondi(), tildTeksto.tondi())
		default:
			assert(false, "Neatendita cheno")
			return ("", "")
		}
	}
}
