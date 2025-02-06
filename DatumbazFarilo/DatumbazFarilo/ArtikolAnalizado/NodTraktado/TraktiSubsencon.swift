extension ArboAnalizilo {
	static func trakti(subsencon subsenco: ArtikolNodo, marko: String?, stato: TraktadoStato) -> String {
		if stato.lastaSubsenco == nil {
			stato.lastaSubsenco = 0
		}
		
		stato.lastaSubsenco? += 1
		stato.nunaSubsenco = stato.lastaSubsenco
		
		var teksto = ""
		traktiFilojn(de: subsenco, stato: stato) { filo in
			switch filo.tipo {
			case .trd, .trdgrp:
				_ = trakti(nodon: filo, stato: stato)
			case .teksto(_):
				// Ignori tekstojn
				break
			default:
				teksto += trakti(nodon: filo, stato: stato) ?? ""
			}
		}
		
		stato.nunaSubsenco = nil
		
		return teksto
	}
}
