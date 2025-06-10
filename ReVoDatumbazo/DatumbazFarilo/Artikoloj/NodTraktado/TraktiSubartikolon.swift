extension ArboAnalizilo {
	static func trakti(subartikolon subartikolo: ArtikolNodo, numero: Int, stato: Stato) {
		stato.artikolFabriko.blokoj.append(.subartikolTitola(teksto: ArtikolTeksto.romajCiferoj(por: numero + 1) + "."))

		var teksto = ""
		
		func malbufrigi() {
			if !teksto.isEmpty {
				stato.artikolFabriko.blokoj.append(.teksta(teksto: teksto))
				teksto = ""
			}
		}
		
		traktiFilojn(de: subartikolo, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .drv(let mrk):
				malbufrigi()
				trakti(derivajhon: filo, marko: mrk, stato: stato)
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .rim:
				teksto += trakti(rimarkon: filo, stato: stato)
			case .snc(let mrk):
				teksto += trakti(sencon: filo, marko: mrk, stato: stato)
			case .teksto:
				break
			case .trd(let lng):
				trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .uzo(let tip):
				teksto += trakti(uzon: filo, tipo: tip, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		malbufrigi()
	}
}
