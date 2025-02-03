import ReVoModelojOSX

func analizi(arbon arbo: ArtikolNodo, indekso: String, lingvoj: [String: Lingvo], stiloj: [String: String]) -> ArtikolAnalizRezulto? {
	let stato = Stato(stiloj: stiloj)
	stato.artikolFabriko.indekso = indekso
	
	_ = traktiFilojn(de: arbo, stato: stato)
	
	return stato.rezultoj(lingvoj: lingvoj)
}

func trakti(nodon nodo: ArtikolNodo, stato: Stato, ampligiTildojn: Bool = true) -> String? {
	switch nodo.tipo {
	case .arbo:
		break
	case .art(let mrk):
		trakti(artikolon: nodo, marko: mrk, stato: stato)
	case .ctl:
		return trakti(citilon: nodo, stato: stato)
	case .dif:
		return trakti(difinon: nodo, stato: stato)
	case .drv(let mrk):
		trakti(derivajhon: nodo, marko: mrk, stato: stato)
	case .ekz:
		return trakti(ekzemplon: nodo, stato: stato)
	case .em:
		return trakti(emfazon: nodo, stato: stato)
	case .esc:
		return trakti(escepton: nodo, stato: stato)
	case .frm:
		return trakti(formulon: nodo, stato: stato)
	case .g:
		return trakti(grasan: nodo, stato: stato)
	case .gra:
		return trakti(gramatikon: nodo, stato: stato)
	case .ind:
		return trakti(indekson: nodo, stato: stato)
	case .k:
		return trakti(kursivon: nodo, stato: stato)
	case .kap:
		_ = trakti(kapon: nodo, stato: stato)
	case .ke:
		return trakti(komunlingvan: nodo, stato: stato)
	case .klr(_):
		return trakti(klarigon: nodo, stato: stato)
	case .lstref:
		return trakti(listReferencon: nodo, stato: stato)
	case .mis:
		return trakti(misstilan: nodo, stato: stato)
	case .mlg:
		return trakti(mallongigon: nodo, stato: stato)
	case .nom:
		return trakti(nomon: nodo, stato: stato)
	case .nac:
		return trakti(nacilingvan: nodo, stato: stato)
	case .ofc:
		return trakti(oficialecon: nodo, stato: stato)
	case .pr:
		return trakti(prononcon: nodo, stato: stato)
	case .rad(let vari):
		return trakti(radikon: nodo, variajho: vari, stato: stato)
	case .ref(let tip, let cel):
		return trakti(referencon: nodo, tipo: tip, celo: cel, stato: stato)
	case .refgrp(let tip):
		return trakti(referencGrupon: nodo, tipo: tip, stato: stato)
	case .rim:
		return trakti(rimarkon: nodo, stato: stato)
	case .sncref(let ref):
		if let ref = ref {
			return trakti(sencReferencon: nodo, marko: ref, stato: stato)
		} else {
			assert(false, "'sncref' sen referenc-atributo aperu ene de 'ref' aŭ 'refgrp' havanta celon")
		}
	case .snc(let mrk):
		return trakti(sencon: nodo, marko: mrk, stato: stato)
	case .sub:
		return trakti(indicon: nodo, stato: stato)
	case .subart:
		trakti(subartikolon: nodo, stato: stato)
	case .subdrv:
		trakti(subderivajhon: nodo, stato: stato)
	case .subsnc(let mrk):
		return trakti(subsencon: nodo, marko: mrk, stato: stato)
	case .sup:
		return trakti(altigitan: nodo, stato: stato)
	case .tezrad:
		break
	case .tld(let lit, let vari):
		if ampligiTildojn {
			return traktiTildon(stato: stato, litero: lit, variajho: vari)
		} else {
			return "~"
		}
	case .trd(let lng):
		// Traktas sendependajn tradukojn. Tiuj ene de 'trdgrp' estos traktataj
		// ene de `trakti(tradukGrupon:...)`
		if let lingvo = lng {
			return trakti(tradukon: nodo, lingvo: lingvo, stato: stato)
		}
		return nil
	case .trdgrp(let lng):
		trakti(tradukGrupon: nodo, lingvo: lng, stato: stato)
		return nil
	case .teksto(let teksto):
		return teksto.prepari()
	case .url(let ref):
		return trakti(URLon: nodo, referenco: ref, stato: stato)
	case .uzo(let tip):
		return trakti(uzon: nodo, tipo: tip, stato: stato)
	case .vari:
		_ = trakti(variajhon: nodo, stato: stato)
	case .vortaro:
		trakti(vortaron: nodo, stato: stato)
	case .vspec:
		return trakti(vortSpecon: nodo, stato: stato)
	case .adm, .aut, .baz, .bib, .bld, .fnt, .lok, .mrk, .vrk:
		break
	}
	
	return nil
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato, ampligiTildojn: Bool = true) -> String {
	var teksto = ""
	traktiFilojn(de: nodo, stato: stato) { filo in
		switch filo.tipo {
		case .fnt:
			// <fnt> ofte enkondukas nenecesajn spacojn - jen ni forigas ilin
			teksto = teksto.tondi()
		default:
			teksto += trakti(nodon: filo, stato: stato, ampligiTildojn: ampligiTildojn) ?? ""
		}
	}
	
	return teksto
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato, farotajh: (ArtikolNodo) -> Void) {
	stato.cheno.append(nodo.tipo)
	stato.sibStako.append(nil)
	
	for filo in nodo.filoj {
		farotajh(filo)
		
		if case .teksto(let sibTeksto) = filo.tipo {
			if !sibTeksto.tondi().isEmpty {
				stato.sibStako[stato.sibStako.count-1] = filo.tipo
			}
		} else {
			stato.sibStako[stato.sibStako.count-1] = filo.tipo
		}
	}
	
	_ = stato.cheno.popLast()
	_ = stato.sibStako.popLast()
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

func trakti(subartikolon subartikolo: ArtikolNodo, stato: Stato) {

	let subartNumero = stato.artikolFabriko.subartikoloj.count + 1

	// 	let sencKvanto = derivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
	
	stato.subartikoloFabriko = SubartikoloFabriko()
	var teksto = ""
	
	traktiFilojn(de: subartikolo, stato: stato) { filo in
		switch filo.tipo {
		case .drv(let mrk):
			trakti(derivajhon: filo, marko: mrk, stato: stato)
		case .dif:
			teksto += trakti(difinon: filo, stato: stato)
		case .snc(let mrk):
			teksto += trakti(sencon: filo, marko: mrk, stato: stato)
		case .teksto(_):
			// Ignoru disajn tekstojn
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	teksto = romajCiferoj(por: subartNumero) + "." + (teksto.isEmpty ? "" : " ") + teksto

	stato.subartikoloFabriko?.teksto = teksto
	
	if let subartikolo = stato.subartikoloFabriko?.fabriki() {
		stato.artikolFabriko.subartikoloj.append(subartikolo)
		stato.subartikoloFabriko = nil
	}
}

func trakti(kapon kapo: ArtikolNodo, stato: Stato) -> (nomo: String, tildo: String) {
	switch stato.cheno.last {
	case .art:
		var teksto = ""
		var tildTeksto = ""
		traktiFilojn(de: kapo, stato: stato) { filo in
			switch filo.tipo {
			case .rad(let vari):
				let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
				teksto += filTeksto
				tildTeksto += "~"
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
				tildTeksto += "~"
			case .ofc:
				stato.artikolFabriko.ofc = trakti(oficialecon: filo, stato: stato)
				// TODO: Aldoni ofc-vortojn
			case .vari:
				let filRezulto = trakti(variajhon: filo, stato: stato)
				teksto += filRezulto.nomo
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari().kunpremi(" ")
				tildTeksto += filTeksto.prepari().kunpremi(" ")
			case .fnt:
				teksto = teksto.tondi()
				tildTeksto = tildTeksto.tondi()
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		stato.artikolFabriko.titolo = teksto.tondi()
		return (teksto, tildTeksto)
	case .drv:
		var teksto = ""
		var tildTeksto = ""
		traktiFilojn(de: kapo, stato: stato) { filo in
			switch filo.tipo {
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
				tildTeksto += "~"
			case .ofc:
				stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
			case .vari:
				let filRezulto = trakti(variajhon: filo, stato: stato)
				teksto += filRezulto.nomo
				tildTeksto += filRezulto.tildo
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari().kunpremi(" ")
				tildTeksto += filTeksto
			case .fnt:
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		stato.vortoFabriko?.titolo = teksto.tondi()
		stato.derivajhNomo = teksto.tondi()
		stato.derivajhTildo = tildTeksto.tondi()
		return (teksto, tildTeksto)
	case .vari:
		var teksto = ""
		var tildTeksto = ""
		traktiFilojn(de: kapo, stato: stato) { filo in
			switch filo.tipo {
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
				tildTeksto += "~"
			case .rad(let vari):
				let filTeksto = trakti(radikon: filo, variajho: vari, stato: stato)
				teksto += filTeksto
				tildTeksto += "~"
			case .ofc:
				if stato.vortoFabriko?.ofc == nil {
					stato.vortoFabriko?.ofc = trakti(oficialecon: filo, stato: stato)
				}
			case .teksto(let filTeksto):
				teksto += filTeksto
				tildTeksto += filTeksto
			case .fnt:
				teksto = teksto.tondi()
				tildTeksto = tildTeksto.tondi()
			default:
				assert(false, "Neatendita filo")
			}
		}
		// La kap-teksto tondiĝis, do ni aldonu kroman spacon
		//stato.vortoFabriko?.titolo? += " " + teksto.tondi()
		return (teksto.tondi(), tildTeksto.tondi())
	default:
		assert(false, "Neatendita cheno")
		return ("", "")
	}
}

func trakti(variajhon variajho: ArtikolNodo, stato: Stato) -> (nomo: String, tildo: String) {
	var rezulto: (nomo: String, tildo: String)? = nil
	traktiFilojn(de: variajho, stato: stato) { filo in
		switch filo.tipo {
		case .kap:
			rezulto = trakti(kapon: filo, stato: stato)
		case .teksto:
			break
		case .uzo:
			// TODO: Trakti uzo en variajho (vd. art-on 'kramf/o')
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	return rezulto!
}
	
func trakti(radikon radiko: ArtikolNodo, variajho: String?, stato: Stato) -> String {
	let teksto = traktiFilojn(de: radiko, stato: stato)
	
	if variajho == nil {
		stato.artikolFabriko.radiko = teksto
	} else if let variajho = variajho {
		stato.artikolRadikVariajhoj[variajho] = teksto
	}
	
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
			_ = trakti(kapon: filo, stato: stato)
		case .mlg:
			// TODO: Trakti kapajn mallongigojn
			break
		case .gra:
			teksto += trakti(gramatikon: filo, stato: stato)
		case .uzo(let tip):
			teksto += trakti(uzon: filo, tipo: tip, stato: stato)
		case .dif:
			teksto += trakti(difinon: filo, stato: stato)
			if sencKvanto > 0 && stato.lastaSenco != sencKvanto {
				teksto += "\n"
			}
		case .tld(let lit, let vari):
			teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
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
		case .subdrv:
			let filTeksto = trakti(subderivajhon: filo, stato: stato)
			
			if let subdrvNumero = stato.lastaSubderivajho {
				if subdrvNumero > 1 {
					teksto += "\n\n"
				}
				teksto += subdrvLitero(por: subdrvNumero)! + ". "
			}
			
			teksto += filTeksto
		case .ref(let tip, let cel):
			teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
		case .refgrp(let tip):
			teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
		case .rim:
			teksto += trakti(rimarkon: filo, stato: stato)
		case .url(let ref):
			teksto += "\n\n" + trakti(URLon: filo, referenco: ref, stato: stato)
		case .trd, .trdgrp:
			_ = trakti(nodon: filo, stato: stato)
		case .fnt:
			switch stato.sibStako.last {
			case .uzo:
				// XXX: Uzoj devas lasi spacon tekst-fine.
				break
			default:
				teksto = teksto.tondi()
			}
		case .adm, .bld, .teksto, .tezrad:
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

func trakti(grasan grasajho: ArtikolNodo, stato: Stato) -> String {
	let filTeksto = traktiFilojn(de: grasajho, stato: stato)
	
	return "<b>" + filTeksto.tondi() + "</b>"
}

func trakti(gramatikon gramatiko: ArtikolNodo, stato: Stato) -> String {
	let filTeksto = traktiFilojn(de: gramatiko, stato: stato)
	
	return "(\(filTeksto))\n"
}

func trakti(vortSpecon vortSpeco: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: vortSpeco, stato: stato)
}

func trakti(subderivajhon subderivajho: ArtikolNodo, stato: Stato) -> String {
	if stato.lastaSubderivajho == nil {
		stato.lastaSubderivajho = 0
	}
	
	stato.lastaSubderivajho? += 1
	stato.nunaSubderivajho = stato.lastaSubderivajho
	
	let sencKvanto = subderivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
	
	var teksto = ""
	traktiFilojn(de: subderivajho, stato: stato) { filo in
		switch filo.tipo {
		case .dif:
			teksto += trakti(difinon: filo, stato: stato)
			if sencKvanto > 0 && stato.lastaSenco != sencKvanto {
				teksto += "\n\n"
			}
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
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	// Eliras sencon
	stato.nunaSubderivajho = nil
	stato.lastaSenco = nil
	
	return teksto
}

func trakti(sencon senco: ArtikolNodo, marko: String?, stato: Stato) -> String {
	if stato.lastaSenco == nil {
		stato.lastaSenco = 0
	}
	
	stato.lastaSenco? += 1
	stato.nunaSenco = stato.lastaSenco
	
	if let marko = marko {
		stato.markSencoj[marko] = stato.nunaSenco
	}
	
	var teksto = ""
	traktiFilojn(de: senco, stato: stato) { filo in
		switch filo.tipo {
		case .kap:
			_ = trakti(kapon: filo, stato: stato)
		case .ekz, .dif, .fnt, .gra, .lstref, .rim, .ref, .refgrp, .uzo:
			teksto += trakti(nodon: filo, stato: stato) ?? ""
		case .tld(let lit, let vari):
			teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
		case .url(let ref):
			teksto += "\n\n" + trakti(URLon: filo, referenco: ref, stato: stato)
		case .trd, .trdgrp:
			_ = trakti(nodon: filo, stato: stato)
		case .subsnc(let mrk):
			let filTeksto = trakti(subsencon: filo, marko: mrk, stato: stato)
			
			if let subsencNombro = stato.lastaSubsenco,
			   let litero = subsencLitero(por: subsencNombro) {
				teksto += "\n\n" + litero + ") "
			}
			teksto += filTeksto
		case .adm, .bld, .teksto, .tezrad:
			break
		case .mlg:
			// Teksto de mallongigo en senco aperu *post* ceterajn tekstojn.
			// Mi ne scias tuje kiel efektivigi tion, kaj, pro tio ke la apo
			// jam ne reprezentas tiajn mallongigojn, mi ne ŝanĝas tion nun.
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

func trakti(subsencon subsenco: ArtikolNodo, marko: String?, stato: Stato) -> String {
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

func trakti(difinon difino: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: difino, stato: stato).kunpremi(" ").tondi()
}

func trakti(ekzemplon ekzemplo: ArtikolNodo, stato: Stato) -> String {
	var teksto = ""
	traktiFilojn(de: ekzemplo, stato: stato) { filo in
		switch filo.tipo {
		case .trd, .trdgrp:
			break
		case .fnt:
			teksto = teksto.tondi()
		default:
			// Mi provis apartigi tiun ĉi linion en pluraj kazoj, tamen la rezulto estis
			// neatendite erarplena
			teksto += trakti(nodon: filo, stato: stato) ?? ""
		}
	}
	return "<i>" + teksto.kunpremi(" ").tondi() + "</i>"
}

func trakti(rimarkon rimarko: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<b>Rim</b>: " + traktiFilojn(de: rimarko, stato: stato).tondi()
	return "\n" + teksto.kunpremi(" ").tondi()
}

func trakti(citilon citilo: ArtikolNodo, stato: Stato) -> String {
	let teksto = "„" + traktiFilojn(de: citilo, stato: stato).tondi() + "”"
	return teksto.kunpremi(" ").tondi()
}

func trakti(emfazon emfazo: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<b>" + traktiFilojn(de: emfazo, stato: stato).tondi() + "</b>"
	return teksto.kunpremi(" ").tondi()
}

func trakti(formulon formulo: ArtikolNodo, stato: Stato) -> String {
	// Formulo ŝajne uzas apartan tiparon (MJXc-TeX-main-*) en la retejo. Esploro indas.
	// vd. ekz. artikolon 'logaritm/o'
	let teksto = traktiFilojn(de: formulo, stato: stato).tondi()
	return teksto.kunpremi(" ").tondi()
}

func trakti(indicon indico: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<sub>" + traktiFilojn(de: indico, stato: stato).tondi() + "</sub>"
	return teksto.kunpremi(" ")
}

func trakti(altigitan altigita: ArtikolNodo, stato: Stato) -> String {
	let teksto = "<sup>" + traktiFilojn(de: altigita, stato: stato).tondi() + "</sup>"
	return teksto.kunpremi(" ")
}

func trakti(nomon nomo: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: nomo, stato: stato).tondi()
}

func trakti(nacilingvan nacilingvajho: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: nacilingvajho, stato: stato)
}

func trakti(
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
		   let simbolo = refSimbolo(tipo: tipo) {
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
		case .teksto(let filteksto):
			teksto += filteksto
		default:
			assert(false, "Neatendita filo")
		}
	}
	teksto += "</a>"
	
	return teksto
}

func trakti(referencGrupon referencGrupo: ArtikolNodo, tipo: String?, stato: Stato) -> String {
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
		case .drv, .snc, .subsnc:
			return true
		default:
			return false
		}
	}()
	
	if montriSimbolon,
	   let tipo = tipo,
	   let simbolo = refSimbolo(tipo: tipo) {
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
		// case .ke:
		case .teksto(_):
			// Ignori nudajn tekstojn
			break
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	return teksto
}

func trakti(listReferencon listReferenco: ArtikolNodo, stato: Stato) -> String {
	// Referenco, similaspecta je la bazaj ref-oj, indikanta vortolisto (ekz. personaj nomoj)
	// Pro tio ke la apo ne nuntempe enhavas tiujn vortolistojn, ni ignoru ĉi-referencojn
	// TODO: Aldoninta listojn, videbligu lstref-ojn
	return ""
}

func trakti(sencReferencon sencReferenco: ArtikolNodo, marko: String, stato: Stato) -> String {
	// Pro tio ke ne eblas antaŭscii la ordon laŭ kiu la artikoloj legiĝos,
	// kaj tio ke (mi supozas) eblas ke estos cirklaj senc-referencoj, ĉi tie
	// nur eblas marki la lokojn en kiu superskriptoj devos aperi. En posta
	// fazo, ni anstataŭos ilin per la finaj tekstoj
	return "<sncref mrk=\"\(marko)\"/>"
}

func traktiTildon(stato: Stato, litero: String?, variajho: String?) -> String {
	var teksto = ""
	if case .ekz = stato.cheno.last {
		teksto += "<b>"
	}
	
	let radiko: String
	if variajho == nil,
	   let artikolRadiko = stato.artikolFabriko.radiko {
		radiko = artikolRadiko
	} else if let variajho = variajho,
			  let variajhRadiko = stato.artikolRadikVariajhoj[variajho] {
		radiko = variajhRadiko
	} else {
		assert(false, "Ne trovis taŭgan radikon por <tld/>")
		return ""
	}

	if let litero = litero {
		teksto += litero + radiko.suffix(from: radiko.index(radiko.startIndex, offsetBy: 1))
	} else {
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
	case "klr", "stl":
		let stilTeksto = stato.stiloj[teksto] ?? teksto
		return "(\(stilTeksto)) "
	default:
		assert(false, "Neatendita stilo")
		return ""
	}
}

func trakti(misstilan misstilajho: ArtikolNodo, stato: Stato) -> String {
	let filTeksto = traktiFilojn(de: misstilajho, stato: stato)
	return "<sup>x</sup>" + filTeksto
}

func trakti(mallongigon mallongigo: ArtikolNodo, stato: Stato) -> String {
	let linio: Bool = {
		switch stato.cheno.last {
		case .kap:
			return false
		default:
			return true
		}
	}()
	
	let teksto = traktiFilojn(de: mallongigo, stato: stato)
	return (linio ? "\n" : "") + "(" + teksto + ")"
}

func trakti(escepton escepto: ArtikolNodo, stato: Stato) -> String {
	return traktiFilojn(de: escepto, stato: stato)
}

func trakti(kursivon kursivajho: ArtikolNodo, stato: Stato) -> String {
	// En la retejo, kursiva teksto aperas en tiparo "TeX-math"
	return traktiFilojn(de: kursivajho, stato: stato)
}
func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: Stato) -> String {
	return "<i>" + traktiFilojn(de: komunlingvajho, stato: stato) + "</i>"
}

func trakti(URLon url: ArtikolNodo, referenco: String?, stato: Stato) -> String {
	// TODO: Trakti url-bazojn en grundo/dtd/vokourl.dtd / jsc/x/voko_entities.ts
	// TODO: Aldoni simbolon ekz. en ankaŭ
	let filTeksto = traktiFilojn(de: url, stato: stato)
	
	if let referenco = referenco {
		return "<a href=\(referenco)>" + filTeksto + "</a>"
	} else {
		return "<a href=\"\(filTeksto)\">\(filTeksto)</a>"
	}
}

// MARK: - Tradukoj

func trakti(tradukon traduko: ArtikolNodo, lingvo: String, stato: Stato) -> String {
	guard let marko = stato.marko else {
		return ""
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
		// TODO: Tradukoj en ekzemploj
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
			senco: stato.nunaSenco,
			subsenco: stato.nunaSubsenco
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
	
	return teksto
}

func trakti(tradukGrupon tradukGrupo: ArtikolNodo, lingvo: String, stato: Stato) {
	traktiFilojn(de: tradukGrupo, stato: stato) { filo in
		switch filo.tipo {
		case .trd(_):
			_ = trakti(tradukon: filo, lingvo: lingvo, stato: stato)
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
