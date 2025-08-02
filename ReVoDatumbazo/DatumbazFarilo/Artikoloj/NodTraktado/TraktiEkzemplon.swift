extension ArboAnalizilo {
	static func trakti(ekzemplon ekzemplo: ArtikolNodo, stila: Bool = true, stato: Stato) -> String {
		var teksto = ""
		var indeksajho: IndeksRezulto?
		
		traktiFilojn(de: ekzemplo, stato: stato) { filo in
			switch filo.tipo {
			case .ctl:
				teksto += trakti(citilon: filo, stato: stato)
			case .em:
				teksto += trakti(emfazon: filo, stato: stato)
			case .esc:
				teksto += trakti(escepton: filo, stato: stato)
			case .fnt:
				teksto = traktiFonton(teksto: teksto, stato: stato)
			case .frm:
				teksto += trakti(formulon: filo, stato: stato)
			case .ind:
				let indeksRezulto = trakti(indekson: filo, stato: stato)
				teksto += indeksRezulto.teksto
				indeksajho = indeksRezulto
			case .klr:
				teksto += trakti(klarigon: filo, stato: stato)
			case .mis:
				teksto += trakti(misstilan: filo, stato: stato)
			case .nac:
				teksto += trakti(nacilingvan: filo, stato: stato)
			case .nom:
				teksto += trakti(nomon: filo, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, montriSimbolon: false, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .sncref(let ref):
				teksto += trakti(sencReferencon: filo, marko: ref!, stato: stato)
			case .sub:
				teksto += trakti(indicon: filo, stato: stato)
			case .sup:
				teksto += trakti(altigitan: filo, stato: stato)
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari()
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			case .ts:
				teksto += trakti(trastrekitan: filo, stato: stato)
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, transpasIndekso: indeksajho, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, transpasIndekso: indeksajho, stato: stato)
			case .uzo(let tip):
				teksto += trakti(uzon: filo, tipo: tip, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		if stila {
			return "\n" + TekstAtributo.volvi(" · " + teksto.kunpremi().tondi(), per: .ekzemplo)
		} else {
			return teksto.kunpremi().tondi()
		}
	}
}
