extension ArboAnalizilo {
	static func trakti(referencGrupon referencGrupo: ArtikolNodo, tipo: String?, stato: Stato) -> String {
		var teksto = ""
		switch stato.sibStako.last {
		case .ref, .refgrp:
			teksto += " "
			break
		default:
			teksto += "\n"
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
			teksto += simbolo + " "
		}
		
		var refNumero = 0
		traktiFilojn(de: referencGrupo, stato: stato) { filo in
			switch filo.tipo {
			case .ref(_, let cel):
				if refNumero > 0 {
					teksto += ", "
				}
				teksto += trakti(
					referencon: filo,
					tipo: tipo,
					celo: cel,
					montriSimbolon: false,
					stato: stato
				)
				refNumero += 1
			case .teksto(_):
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto
	}
}
