import ReVoModelojOSX

func analizi(arbon arbo: ArtikolNodo, indekso: String, lingvoj: [String: Lingvo], stiloj: [String: String]) -> ArtikolAnalizRezulto? {
	let stato = Stato(stiloj: stiloj)
	stato.artikolFabriko.indekso = indekso
	
	_ = traktiFilojn(de: arbo, stato: stato)
	
	return stato.rezultoj(lingvoj: lingvoj)
}

func trakti(nodon nodo: ArtikolNodo, stato: Stato, ampligiTildojn: Bool = true) -> String? {
	switch nodo.tipo {
	case .radiko:
		break
	case .vortaro:
		trakti(vortaron: nodo, stato: stato)
	case .art(let mrk):
		trakti(artikolon: nodo, marko: mrk, stato: stato)
	case .kap:
		trakti(kapon: nodo, stato: stato)
	case .rad:
		return trakti(radikon: nodo, stato: stato)
	case .ofc:
		return trakti(oficialecon: nodo, stato: stato)
	case .drv(let mrk):
		trakti(derivajhon: nodo, marko: mrk, stato: stato)
	case .tld:
		if ampligiTildojn {
			return traktiTildon(stato: stato)
		} else {
			return "~"
		}
	case .gra:
		return trakti(gramatikon: nodo, stato: stato)
	case .vspec:
		return trakti(vortSpecon: nodo, stato: stato)
	case .snc(let mrk):
		return trakti(sencon: nodo, marko: mrk, stato: stato)
	case .subsnc:
		return trakti(subsencon: nodo, stato: stato)
	case .uzo(let tip):
		return trakti(uzon: nodo, tipo: tip, stato: stato)
	case .dif:
		return trakti(difinon: nodo, stato: stato)
	case .ekz:
		return trakti(ekzemplon: nodo, stato: stato)
	case .rim:
		return trakti(rimarkon: nodo, stato: stato)
	case .fnt, .aut, .bib, .lok, .vrk, .nom:
		break
	case .klr(_):
		return trakti(klarigon: nodo, stato: stato)
	case .ref(let tip, let cel):
		return trakti(referencon: nodo, tipo: tip!, celo: cel, stato: stato)
	case .refgrp(let tip):
		return trakti(referencGrupon: nodo, tipo: tip, stato: stato)
	case .sncref(let ref):
		return trakti(sencReferencon: nodo, marko: ref, stato: stato)
	case .trd(let lng):
		// Traktas sendependajn tradukojn. Tiuj ene de 'trdgrp' estos traktataj
		// ene de `trakti(tradukGrupon:...)`
		if let lingvo = lng {
			trakti(tradukon: nodo, lingvo: lingvo, stato: stato)
		}
		return nil
	case .trdgrp(let lng):
		trakti(tradukGrupon: nodo, lingvo: lng, stato: stato)
		return nil
	case .pr:
		return trakti(prononcon: nodo, stato: stato)
	case .ind:
		return trakti(indekson: nodo, stato: stato)
	case .url(let ref):
		return trakti(URLon: nodo, referenco: ref, stato: stato)
	case .teksto(let teksto):
		return teksto.prepari()
	}
	
	return nil
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato, ampligiTildojn: Bool = true) -> String {
	stato.cheno.append(nodo.tipo)
	
	var teksto = ""
	
	for filo in nodo.filoj {
		switch filo.tipo {
		case .fnt:
			// <fnt> ofte enkondukas nenecesajn spacojn - jen ni forigas ilin
			teksto = teksto.tondi()
		default:
			teksto += trakti(nodon: filo, stato: stato, ampligiTildojn: ampligiTildojn) ?? ""
		}
	}
	
	_ = stato.cheno.popLast()
	return teksto
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato, farotajh: (ArtikolNodo) -> Void) {
	stato.cheno.append(nodo.tipo)
	
	for filo in nodo.filoj {
		farotajh(filo)
	}
	
	_ = stato.cheno.popLast()
}

func trakti(vortaron vortaro: ArtikolNodo, stato: Stato) {
	_ = traktiFilojn(de: vortaro, stato: stato)
}

func trakti(artikolon artikolo: ArtikolNodo, marko: String?, stato: Stato) {
	_ = traktiFilojn(de: artikolo, stato: stato)
	
	if stato.subartikoloFabriko != nil {
		let novaSubartikolo = stato.subartikoloFabriko?.fabriki()
		stato.artikolFabriko.subartikoloj.append(novaSubartikolo!)
	}
}

func trakti(kapon kapo: ArtikolNodo, stato: Stato) {
	switch stato.cheno.last {
	case .art:
		var teksto = ""
		traktiFilojn(de: kapo, stato: stato) { filo in
			let filTeksto = trakti(nodon: filo, stato: stato)
			switch filo.tipo {
			case .ofc:
				stato.artikolFabriko.ofc = filTeksto
			default:
				teksto += filTeksto ?? ""
			}
		}
		stato.artikolFabriko.titolo = teksto.tondi()
	case .drv:
		let teksto = traktiFilojn(de: kapo, stato: stato)
		stato.vortoFabriko?.titolo = teksto.tondi()
	default:
		break
	}

	stato.derivajhNomo = traktiFilojn(de: kapo, stato: stato, ampligiTildojn: true)
	stato.derivajhTildo = traktiFilojn(de: kapo, stato: stato, ampligiTildojn: false)
}

func trakti(radikon radiko: ArtikolNodo, stato: Stato) -> String {
	let teksto = traktiFilojn(de: radiko, stato: stato)
	
	stato.artikolFabriko.radiko = teksto
	
	return teksto
}

func trakti(oficialecon oficialeco: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: oficialeco, stato: stato).tondi()
}

func trakti(derivajhon derivajho: ArtikolNodo, marko: String, stato: Stato) {
	stato.vortoFabriko = VortoFabriko()
	stato.vortoFabriko?.marko = marko
	
	var teksto = ""
	let sencKvanto = derivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
	
	traktiFilojn(de: derivajho, stato: stato) { filo in
		switch filo.tipo {
		case .kap:
			trakti(kapon: filo, stato: stato)
		case .gra:
			teksto += trakti(gramatikon: filo, stato: stato)
		case .snc(let mrk):
			let filTeksto = trakti(sencon: filo, marko: mrk, stato: stato)
			
			if sencKvanto > 1,
			   let sencNombro = stato.lastaSenco {
				if sencNombro > 1 {
					teksto += "\n\n"
				}
				teksto += String(sencNombro) + ". "
			}
			
			teksto += filTeksto
		case .trd, .trdgrp:
			_ = trakti(nodon: filo, stato: stato)
		case .teksto:
			// Ignori sendependajn tekstojn
			break
		default:
			assert(false, "Neatendita filo")
		}
	}

	// let teksto = traktiFilojn(de: derivajho, stato: stato)
	stato.vortoFabriko?.teksto = teksto.kunpremi(" ").tondi()
	
	if stato.subartikoloFabriko == nil {
		stato.subartikoloFabriko = SubartikoloFabriko()
	}
	
	let novaVorto = stato.vortoFabriko?.fabriki()
	stato.subartikoloFabriko?.vortoj.append(novaVorto!)
	
	// Eliras derivaĵon
	stato.derivajhNomo = nil
	stato.derivajhTildo = nil
	stato.lastaSenco = nil
}

func trakti(gramatikon gramatiko: ArtikolNodo, stato: Stato) -> String {
	let filTeksto = traktiFilojn(de: gramatiko, stato: stato)
	
	return "(\(filTeksto))\n"
}

func trakti(vortSpecon vortSpeco: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: vortSpeco, stato: stato)
}

func trakti(sencon senco: ArtikolNodo, marko: String?, stato: Stato) -> String {
	if stato.lastaSenco == nil {
		stato.lastaSenco = 0
	}
	
	stato.lastaSenco? += 1
	stato.nunaSenco = stato.lastaSenco
	
	if let marko = marko {
		stato.sencMarkoj[marko] = stato.nunaSenco
	}
	
	let subsencKvanto = senco.filoj.map { if case .subsnc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
	var teksto = ""
	traktiFilojn(de: senco, stato: stato) { filo in
		switch filo.tipo {
		case .kap:
			trakti(kapon: filo, stato: stato)
		case .uzo, .dif, .rim, .ref, .refgrp, .trd, .trdgrp:
			teksto += trakti(nodon: filo, stato: stato) ?? ""
		case .subsnc:
			let filTeksto = trakti(subsencon: filo, stato: stato)
			
			if subsencKvanto > 1,
			   let subsencNombro = stato.lastaSubsenco,
			   let litero = subsencLitero(por: subsencNombro) {
				teksto += "\n\n" + litero + ") "
			}
			teksto += filTeksto
		case .fnt:
			break
		case .teksto(_):
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	// Eliras sencon
	stato.nunaSenco = nil
	stato.lastaSubsenco = nil
	
	return teksto
}

func trakti(subsencon subsenco: ArtikolNodo, stato: Stato) -> String {
	if stato.lastaSubsenco == nil {
		stato.lastaSubsenco = 0
	}
	
	stato.lastaSubsenco? += 1
	stato.nunaSubsenco = stato.lastaSubsenco
	
	let filTeksto = traktiFilojn(de: subsenco, stato: stato)
	
	stato.nunaSubsenco = nil
	
	return filTeksto
}

func trakti(difinon difino: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: difino, stato: stato).kunpremi(" ").tondi()
}

func trakti(ekzemplon ekzemplo: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<i>" + traktiFilojn(de: ekzemplo, stato: stato).tondi() + "</i>"
	return teksto.kunpremi(" ").tondi()
}

func trakti(rimarkon rimarko: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<b>Rim</b>: " + traktiFilojn(de: rimarko, stato: stato).tondi()
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

func trakti(referencGrupon referencGrupo: ArtikolNodo, tipo: String, stato: Stato) -> String {
	var teksto = ""
	traktiFilojn(de: referencGrupo, stato: stato) { filo in
		switch filo.tipo {
		case .ref(_, let cel):
			teksto += trakti(referencon: filo, tipo: tipo, celo: cel, stato: stato)
		// case .ke:
		case .teksto(let filTeksto):
			// teksto += filTeksto
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	return teksto
}

func trakti(sencReferencon sencReferenco: ArtikolNodo, marko: String, stato: Stato) -> String {
	return "!!!SNCREF!!!"
}

func traktiTildon(stato: Stato) -> String {
	var teksto = ""
	if case .ekz = stato.cheno.last {
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

func trakti(uzon uzo: ArtikolNodo, tipo: String, stato: Stato) -> String {
	let teksto = traktiFilojn(de: uzo, stato: stato)
	
	switch tipo {
	case "fak":
		return "[\(teksto)] "
	case "stl":
		let stilTeksto = stato.stiloj[teksto] ?? teksto
		return "(\(stilTeksto)) "
	default:
		assert(false, "Neatendita stilo")
	}
}

func trakti(URLon url: ArtikolNodo, referenco: String, stato: Stato) -> String {
	return "<a href=\(referenco)>" + traktiFilojn(de: url, stato: stato)
}

// MARK: - Tradukoj

func trakti(tradukon traduko: ArtikolNodo, lingvo: String, stato: Stato) {
	guard let marko = stato.marko else {
		return
	}
	
	var serchNomo: String?
	var teksto = ""
	
	traktiFilojn(de: traduko, stato: stato) { filo in
		let filTeksto = trakti(nodon: filo, stato: stato)
		
		switch filo.tipo {
		case .ind:
			serchNomo = filTeksto
		default:
			break
		}
		teksto += filTeksto ?? ""
	}
	
	teksto = teksto.kunpremi(" ")
	
	if false {
		// Tradukoj en ekzemploj
//		let artikolTraduko = ArtikolTraduko(
//			nomo: indekso,
//			teksto: teksto,
//			marko: marko,
//			senco: stato.sncNombro
//		)
//		stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
	} else if let nomo = stato.derivajhNomo,
			  let tildo = stato.derivajhTildo,
			  let indekso = stato.artikolIndekso {
		let artikolTraduko = ArtikolTraduko(
			nomo: tildo,
			teksto: teksto,
			marko: marko,
			senco: stato.nunaSenco
		)
		stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
		
		let serchTraduko = SerchTraduko(
			videblaNomo: serchNomo ?? teksto,
			nomo: nomo,
			teksto: teksto,
			indekso: indekso,
			marko: marko,
			senco: stato.nunaSenco
		)
		stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
	}
}

func trakti(tradukGrupon tradukGrupo: ArtikolNodo, lingvo: String, stato: Stato) {
	traktiFilojn(de: tradukGrupo, stato: stato) { filo in
		switch filo.tipo {
		case .trd(_):
			trakti(tradukon: filo, lingvo: lingvo, stato: stato)
		default:
			break
		}
	}
}

func trakti(indekson indekso: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: indekso, stato: stato)
}

func trakti(klarigon klarigo: ArtikolNodo, stato: Stato) -> String {
	var teksto = traktiFilojn(de: klarigo, stato: stato)
	
	// Liveri tekston, sen emfazoj (ekz. "Banderolo" en)
	teksto = teksto.replacingOccurrences(of: "<em>", with: "")
	teksto = teksto.replacingOccurrences(of: "</em>", with: "")
	
	return teksto
}

func trakti(prononcon prononco: ArtikolNodo, stato: Stato) -> String {
	let teksto = traktiFilojn(de: prononco, stato: stato)
	return "[" + teksto + "]"
}

// ATENTU
// En 'provludi' - tradukoj ekzistas por 'prov~o', kiu NE APERAS KIEL DERIVAĴO

// Eraroj en 'not/i'
