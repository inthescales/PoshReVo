extension ArboAnalizilo {
	static func trakti(sencon senco: ArtikolNodo, marko: String?, stato: Stato) -> String {
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
			case .adm, .bld:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .ekz:
				teksto += trakti(ekzemplon: filo, stato: stato)
			case .fnt:
				teksto = teksto.tondi()
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .kap:
				_ = trakti(kapon: filo, stato: stato)
			case .lstref(let lst):
				teksto += trakti(listReferencon: filo, listo: lst, stato: stato)
			case .mlg:
				// Teksto de mallongigo en senco aperu *post* ceterajn tekstojn.
				// Mi ne scias tuje kiel efektivigi tion, kaj, pro tio ke la apo
				// jam ne reprezentas tiajn mallongigojn, mi ne ŝanĝas tion nun.
				break
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .rim:
				teksto += trakti(rimarkon: filo, stato: stato)
			case .subsnc(let mrk):
				let filTeksto = trakti(subsencon: filo, marko: mrk, stato: stato)
				
				if let subsencNombro = stato.lastaSubsenco,
				   let litero = ArtikolTeksto.subsencLitero(por: subsencNombro) {
					teksto += "\n\n" + TekstAtributo.volvi(tekston: litero + ") ", per: .sencNumero)
				}
				teksto += filTeksto
			case .teksto, .tezrad:
				break
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			case .trd(let lng):
				trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .url(let ref):
				teksto += "\n\n" + trakti(URLon: filo, referenco: ref, stato: stato)
			case .uzo(let tip):
				teksto += trakti(uzon: filo, tipo: tip, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		// Eliras sencon
		stato.nunaSenco = nil
		stato.lastaSubsenco = nil
		
		return teksto
	}
}
