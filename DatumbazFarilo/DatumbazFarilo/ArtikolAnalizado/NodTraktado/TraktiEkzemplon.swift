extension ArboAnalizilo {
	static func trakti(ekzemplon ekzemplo: ArtikolNodo, stato: TraktadoStato) -> String {
		var teksto = ""
		traktiFilojn(de: ekzemplo, stato: stato) { filo in
			switch filo.tipo {
			case .trd, .trdgrp:
				break
			case .fnt:
				teksto = teksto.tondi()
			case .ind:
				// TODO: Plene trakti indeksojn
				teksto += trakti(indekson: filo, stato: stato).0
			default:
				// Mi provis apartigi tiun ĉi linion en pluraj kazoj, tamen la rezulto estis
				// neatendite erarplena
				teksto += trakti(nodon: filo, stato: stato) ?? ""
			}
		}
		return "<i>" + teksto.kunpremi().tondi() + "</i>"
	}
}
