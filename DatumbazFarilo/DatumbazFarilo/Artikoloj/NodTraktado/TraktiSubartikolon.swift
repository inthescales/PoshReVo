extension ArboAnalizilo {
	static func trakti(subartikolon subartikolo: ArtikolNodo, stato: TraktadoStato) {
		
		let subartNumero = stato.artikolFabriko.subartikoloj.count + 1
		
		stato.subartikoloFabriko = SubartikoloFabriko()
		var teksto = ""
		
		traktiFilojn(de: subartikolo, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .drv(let mrk):
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
		
		teksto = ArtikolTeksto.romajCiferoj(por: subartNumero) + "." + (teksto.isEmpty ? "" : " ") + teksto
		
		stato.subartikoloFabriko?.teksto = teksto
		
		if let subartikolo = stato.subartikoloFabriko?.fabriki() {
			stato.artikolFabriko.subartikoloj.append(subartikolo)
			stato.subartikoloFabriko = nil
		}
	}
}
