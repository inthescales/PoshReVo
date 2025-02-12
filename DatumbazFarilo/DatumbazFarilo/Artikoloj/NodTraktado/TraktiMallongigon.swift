extension ArboAnalizilo {
	struct MallongigoRezulto {
		/// Teksto de la <ind> en sia plena formo (<tld/> fariĝas kapvorton)
		let teksto: String
		
		/// Teksto de la <ind> en tildhava formo (<tld/> restas `~`)
		let tildTeksto: String
	}
	
	static func trakti(mallongigon mallongigo: ArtikolNodo, stato: TraktadoStato) -> MallongigoRezulto {
		let linio: Bool = {
			switch stato.cheno.last {
			case .kap, .ind:
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
		var tildTeksto = ""
		traktiFilojn(de: mallongigo, stato: stato) { filo in
			switch filo.tipo {
			case .ind:
				// Indekso ene de mallongigo ŝajne ne havas efikon
				// Ekz. 'grav/i', tradukoj ĉe "sed tio ne gravas"
				let filTeksto = trakti(indekson: filo, stato: stato).teksto
				teksto += filTeksto
				tildTeksto += filTeksto
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
		
		var rezulto = ""
		if linio {
			rezulto += "\n"
		}
		
		if parentezoj {
			rezulto += "(" + teksto + ")"
		} else {
			rezulto += teksto
		}
		
		return MallongigoRezulto(teksto: teksto, tildTeksto: tildTeksto)
	}
}
