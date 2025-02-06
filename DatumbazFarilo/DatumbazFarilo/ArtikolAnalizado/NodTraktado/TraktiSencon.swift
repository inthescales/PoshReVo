extension ArboAnalizilo {
	static func trakti(sencon senco: ArtikolNodo, marko: String?, stato: TraktadoStato) -> String {
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
				   let litero = ArtikolTeksto.subsencLitero(por: subsencNombro) {
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
}
