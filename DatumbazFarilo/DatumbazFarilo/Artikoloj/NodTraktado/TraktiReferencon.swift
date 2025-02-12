extension ArboAnalizilo {
	static func trakti(
		referencon referenco: ArtikolNodo,
		tipo: String?,
		celo: String,
		montriSimbolon: Bool = true,
		stato: Stato
	) -> String {
		var teksto = ""
		
		switch stato.cheno.last {
		case .drv, .snc:
			switch stato.sibStako.last {
			case .ref, .refgrp:
				teksto += " "
				break
			default:
				teksto += "\n"
			}
			
			if montriSimbolon,
			   let tipo = tipo,
			   let simbolo = ArtikolTeksto.refSimbolo(tipo: tipo) {
				teksto += simbolo + " "
			}
		default:
			break
		}
		
		teksto += "<a href=\"\(celo)\">"
		traktiFilojn(de: referenco, stato: stato) { filo in
			switch filo.tipo {
			case .sncref(let ref):
				teksto += trakti(sencReferencon: filo, marko: ref ?? celo, stato: stato)
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			case .klr:
				teksto += trakti(klarigon: filo, stato: stato)
			case .teksto(let filteksto):
				teksto += filteksto
			default:
				assert(false, "Neatendita filo")
			}
		}
		teksto += "</a>"
		
		return teksto
	}
}
