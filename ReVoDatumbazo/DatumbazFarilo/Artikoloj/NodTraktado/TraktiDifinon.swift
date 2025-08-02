extension ArboAnalizilo {
	static func trakti(difinon difino: ArtikolNodo, stato: Stato) -> String {
		var teksto = ""
		
		traktiFilojn(de: difino, stato: stato) { filo in
			switch filo.tipo {
			case .aut:
				teksto += trakti(autoron: filo, stato: stato)
			case .ctl:
				teksto += trakti(citilon: filo, stato: stato)
			case .ekz:
				teksto += trakti(ekzemplon: filo, stato: stato)
			case .esc:
				teksto += trakti(escepton: filo, stato: stato)
			case .em:
				teksto += trakti(emfazon: filo, stato: stato)
			case .fnt:
				teksto = traktiFonton(teksto: teksto, stato: stato)
			case .frm:
				teksto += trakti(formulon: filo, stato: stato)
			case .g:
				teksto += trakti(grasan: filo, stato: stato)
			case .k:
				teksto += trakti(kursivon: filo, stato: stato)
			case .ke:
				teksto += trakti(komunlingvan: filo, stato: stato)
			case .klr:
				teksto += trakti(klarigon: filo, stato: stato)
			case .mis:
				teksto += trakti(misstilan: filo, stato: stato)
			case .nac:
				teksto += trakti(nacilingvan: filo, stato: stato)
			case .nom:
				teksto += trakti(nomon: filo, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .snc:
				// Mi ne scias kial, tamen ja eblas ke senco aperu ene de difino.
				// Vidu artikolo 'nimb/o'. Tie, la artikolo aperas samkiel estus
				// kelkaj sencoj vice. Aŭ tio estas eraro ReVo-e, aŭ mi devas serĉi
				// maniero trakti ĝin.
				// Ŝajnas ke la ununura artikolo havanta ĉi tian strukturon estas 'nimb/o',
				// do plej verŝajne estos plej bone ŝanĝi ĝin. Tiukaze, eblos uzi 'akumuliTekstojn'
				// ĉi-metode.
				// TODO: Faru ion.
				break
			case .sncref(let ref):
				if let ref = ref {
					teksto += trakti(sencReferencon: filo, marko: ref, stato: stato)
				} else {
					assert(false, "'sncref' sen referenc-atributo aperu ene de 'ref' aŭ 'refgrp' havanta celon")
				}
			case .sub:
				teksto += trakti(indicon: filo, stato: stato)
			case .sup:
				teksto += trakti(altigitan: filo, stato: stato)
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari()
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			case .trd(let lng):
				teksto += trakti(tradukon: filo, lingvo: lng!, stato: stato) ?? ""
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto.kunpremi().tondi()
	}
}
