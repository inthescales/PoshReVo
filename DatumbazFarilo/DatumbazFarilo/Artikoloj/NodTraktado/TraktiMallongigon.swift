extension ArboAnalizilo {
	static func trakti(mallongigon mallongigo: ArtikolNodo, stato: TraktadoStato) -> String {
		let linio: Bool = {
			switch stato.cheno.last {
			case .kap:
				return false
			default:
				return true
			}
		}()
		
		let parentezoj: Bool = {
			switch stato.cheno.last {
			case .ind, .trd:
				return false
			default:
				return true
			}
		}()
		
		var teksto = ""
		traktiFilojn(de: mallongigo, stato: stato) { filo in
			switch filo.tipo {
			case .ind:
				// TODO: Plene trakti indeksojn kaj mallongigojn
				teksto += trakti(indekson: filo, stato: stato).0
			case .teksto(let filTeksto):
				teksto += filTeksto
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		var rezulto = ""
		if linio {
			rezulto += "\n"
		}
		if parentezoj {
			rezulto += "(" + teksto + ")"
		} else {
			rezulto += teksto
		}
		
		return rezulto
	}
}
