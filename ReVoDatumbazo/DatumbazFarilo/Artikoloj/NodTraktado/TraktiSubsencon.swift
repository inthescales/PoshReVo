extension ArboAnalizilo {
	static func trakti(subsencon subsenco: ArtikolNodo, marko: String?, stato: Stato) -> String {
		if stato.lastaSubsenco == nil {
			stato.lastaSubsenco = 0
		}
		
		stato.lastaSubsenco? += 1
		stato.nunaSubsenco = stato.lastaSubsenco
		
		if let marko = marko,
		   let senco = stato.nunaSenco,
		   let subsenco = stato.nunaSubsenco {
			stato.markSencoj[marko] = (senco, subsenco)
		}
		
		var teksto = ""
		traktiFilojn(de: subsenco, stato: stato) { filo in
			switch filo.tipo {
			case .adm, .bld:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .ekz:
				teksto += trakti(ekzemplon: filo, stato: stato)
			case .fnt:
				teksto = ignoriFonton(teksto: teksto, stato: stato)
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .lstref(let lst):
				teksto += trakti(listReferencon: filo, listo: lst, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .rim(let num):
				teksto += trakti(rimarkon: filo, numero: num, stato: stato)
			case .teksto, .tezrad:
				break
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
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
		
		stato.nunaSubsenco = nil
		
		return teksto
	}
}
