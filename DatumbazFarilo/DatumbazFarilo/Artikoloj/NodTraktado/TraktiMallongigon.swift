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
				// Indekso ene de mallongigo ŝajne ne havas efikon
				// Ekz. 'grav/i', tradukoj ĉe "sed tio ne gravas"
				teksto += trakti(indekson: filo, stato: stato).teksto
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari().kunpremi()
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
