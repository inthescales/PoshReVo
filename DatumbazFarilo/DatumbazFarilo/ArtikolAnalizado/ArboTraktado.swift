import ReVoModelojOSX

func kreiArtikolon(el arbo: ArtikolNodo, indekso: String) -> Artikolo {
	let stato = Stato()
	stato.artikolFabriko.indekso = indekso
	
	traktiFilojn(de: arbo, stato: stato)
	
	return stato.artikolFabriko.fabriki()!
}

func trakti(nodon nodo: ArtikolNodo, stato: Stato) -> String? {
	switch nodo.tipo {
	case .radiko:
		break
	case .vortaro:
		trakti(vortaron: nodo, stato: stato)
	case .art:
		trakti(artikolon: nodo, stato: stato)
	case .kap:
		trakti(kapon: nodo, stato: stato)
	case .rad:
		trakti(radikon: nodo, stato: stato)
	case .drv(mrk: let mrk):
		trakti(derivajhon: nodo, stato: stato)
	case .tld:
		return traktiTildon(stato: stato)
	case .snc:
		return trakti(sencon: nodo, stato: stato)
	case .uzo(tip: let tip):
		return trakti(uzon: nodo, stato: stato)
	case .dif:
		return trakti(difinon: nodo, stato: stato)
	case .ekz:
		return trakti(ekzemplon: nodo, stato: stato)
	case .fnt, .bib, .lok, .vrk:
		break
	case .klr(tip: let tip):
		break
	case .ref(tip: let tip, cel: let cel):
		return trakti(referencon: nodo, tipo: tip, celo: cel, stato: stato)
	case .trd(lng: let lng):
		break
	case .trdgrp(lng: let lng):
		break
	case .pr:
		break
	case .ind:
		break
	case .url(ref: let ref):
		return trakti(URLon: nodo, stato: stato)
	case .teksto(let teksto):
		return prepari(tekston: teksto)
	}
	
	return nil
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato) -> String {
	stato.cheno.append(nodo.tipo)
	
	var teksto = ""
	
	for filo in nodo.filoj {
		switch filo.tipo {
		case .fnt:
			// <fnt> ofte enkondukas nenecesajn spacojn - jen ni forigas ilin
			teksto = teksto.tondi()
		default:
			teksto += trakti(nodon: filo, stato: stato) ?? ""
		}
	}
	
	_ = stato.cheno.popLast()
	return teksto
}

func trakti(vortaron vortaro: ArtikolNodo, stato: Stato) {
	_ = traktiFilojn(de: vortaro, stato: stato)
}

func trakti(artikolon artikolo: ArtikolNodo, stato: Stato) {
	_ = traktiFilojn(de: artikolo, stato: stato)
	
	if stato.subartikoloFabriko != nil {
		let novaSubartikolo = stato.subartikoloFabriko?.fabriki()
		stato.artikolFabriko.subartikoloj.append(novaSubartikolo!)
	}
}

func trakti(kapon kapo: ArtikolNodo, stato: Stato) {
	let teksto = traktiFilojn(de: kapo, stato: stato)
	
	switch stato.cheno.last {
	case .art:
		stato.artikolFabriko.titolo = teksto
	case .drv:
		stato.vortoFabriko?.titolo = teksto
	default:
		break
	}
	
	stato.nuligiBufron()
}

func trakti(radikon radiko: ArtikolNodo, stato: Stato) {
	let teksto = traktiFilojn(de: radiko, stato: stato)
	
	stato.artikolFabriko.radiko = teksto
}

func trakti(derivajhon derivajho: ArtikolNodo, stato: Stato) {
	stato.vortoFabriko = VortoFabriko()
	if case .drv(let marko) = derivajho.tipo {
		stato.vortoFabriko?.marko = marko
	}
	
	var teksto = ""
	var sencoj = 0
	let sencKvanto = derivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
	
	stato.cheno.append(derivajho.tipo)
	for filo in derivajho.filoj {
		if case .snc = filo.tipo, sencKvanto > 1 {
			sencoj += 1
			if sencoj > 1 {
				teksto += "\n\n"
			}
			teksto += String(sencoj) + ". "
		}
		
		teksto += trakti(nodon: filo, stato: stato) ?? ""
	}
	_ = stato.cheno.popLast()
	
	// let teksto = traktiFilojn(de: derivajho, stato: stato)
	stato.vortoFabriko?.teksto = teksto.tondi()
	
	if stato.subartikoloFabriko == nil {
		stato.subartikoloFabriko = SubartikoloFabriko()
	}
	
	let novaVorto = stato.vortoFabriko?.fabriki()
	stato.subartikoloFabriko?.vortoj.append(novaVorto!)
}

func trakti(sencon senco: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: senco, stato: stato).kunpremi(" ").tondi()
}

func trakti(difinon difino: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: difino, stato: stato).kunpremi(" ")
}

func trakti(ekzemplon ekzemplo: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<i>" + traktiFilojn(de: ekzemplo, stato: stato).tondi() + "</i>"
	return teksto.kunpremi(" ").tondi()
}

func trakti(referencon referenco: ArtikolNodo, tipo: String, celo: String, stato: Stato) -> String {
	var teksto = ""
	
	if case .dif = stato.cheno.last {} else {
		teksto += "\n"
		if let simbolo = refSimbolo(tipo: tipo) {
			teksto += simbolo + " "
		}
	}

	teksto += "<a href=\"\(celo)\">"
	teksto += traktiFilojn(de: referenco, stato: stato)
	teksto += "</a>"
	
	return teksto
}

func traktiTildon(stato: Stato) -> String {
	var teksto = ""
	if case .ekz = stato.cheno.last {
		stato.spaciBufron()
		teksto += "<b>"
	}
	
	if let radiko = stato.artikolFabriko.radiko {
		teksto += radiko
	}
	
	if case .ekz = stato.cheno.last {
		teksto += "</b>"
	}
	
	return teksto
}

func trakti(uzon uzo: ArtikolNodo, stato: Stato) -> String {
	var teksto = ""
	if case .uzo(let tipo) = uzo.tipo {
		if tipo == "fak" {
			teksto += "["
		}
	}
	
	teksto += traktiFilojn(de: uzo, stato: stato)
	
	if case .uzo(let tipo) = uzo.tipo {
		if tipo == "fak" {
			teksto += "] "
		}
	}
	
	return teksto
}

func trakti(URLon url: ArtikolNodo, stato: Stato) -> String {
	if case .url(let ref) = url.tipo {
		return "<a href=\(ref)>" + traktiFilojn(de: url, stato: stato)
	}
	
	return ""
}
