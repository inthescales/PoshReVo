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
		case .drv, .snc, .subdrv, .subsnc:
			let lastaSibo = stato.sibStako.last ?? nil
			switch lastaSibo {
			case .fnt, .ref, .refgrp, .teksto, .uzo:
				// ekzemploj:
				// teksto:  	prem/i
				// fnt/ uzo: 	ĵet/o (2)
				//
				// TODO: ĉu tipo "dif" sufiĉas? Esplori
				teksto += " "
				break
			case nil:
				// ekz. flar/o, sak/o
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
				// Kelkfoje troviĝas kroma spaco post teksto ĉi-tie, tamen tondado kaŭzus problemojn
				// en kazoj kiel "<ref tip="sin" cel="arab.SaudaA0ujo">Sauda <tld lit="A"/>ujo</ref>"
				teksto += filteksto.prepari()
			default:
				assert(false, "Neatendita filo")
			}
		}
		teksto += "</a>"
		
		return teksto
	}
}
