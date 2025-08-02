extension ArboAnalizilo {
	static func trakti(
		referencGrupon referencGrupo: ArtikolNodo,
		tipo: String?,
		stato: Stato
	) -> String {
		var prefikso = ""
		
		switch stato.cheno.last {
		case .drv, .snc, .subdrv, .subsnc:
			switch stato.sibStako.last {
			case .fnt, .ref, .refgrp, .teksto, .uzo:
				prefikso += " "
				break
			default:
				prefikso += "\n"
			}
		default:
			break
		}
		
		let montriSimbolon = {
			switch stato.cheno.last {
			case .art, .drv, .snc, .subart, .subdrv, .subsnc:
				return true
			default:
				return false
			}
		}()
		
		if montriSimbolon,
		   let tipo = tipo,
		   let simbolo = ArtikolTeksto.refSimbolo(tipo: tipo) {
			prefikso += simbolo + " "
		}
		
		var teksto = ""
		var refNumero = 0
		traktiFilojn(de: referencGrupo, stato: stato) { filo in
			switch filo.tipo {
			case .ref(_, let cel):
				teksto += trakti(
					referencon: filo,
					tipo: tipo,
					celo: cel,
					montriSimbolon: false,
					stato: stato
				)
				refNumero += 1
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari()
			default:
				assert(false, "Neatendita filo")
			}
		}
		teksto = teksto.tondi()
		
		return prefikso + teksto
	}
}
