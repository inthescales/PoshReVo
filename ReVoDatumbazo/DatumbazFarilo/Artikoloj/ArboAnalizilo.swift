enum ArboAnalizilo {
	/// Rezulto de analizo de artikol-dokumento.
	struct Rezulto {
		/// Ĉiuj datumoj per kiu artikolo estos prezentata
		let artikolo: Artikolo
		
		/// Tradukoj kiuj estos serĉeblaj
		let serchTradukoj: [String: [SerchTraduko]]
		
		/// Esperantaj vortoj kiuj estos serĉeblaj
		let serchVortoj: [SerchVorto]
		
		/// Fakaj vortoj aperontaj en fakvortaj listoj
		let fakVortoj: [String: [FakVorto]]
		
		/// Vortoj aperontaj en listo da vortoj laŭ oficialeco
		let ofcVortoj: [Oficialeco: [OfcVorto]]
		
		/// Markoj kaj siaj kunligitaj sencoj kaj subsencoj
		let markSencoj: [String: (Int, Int?)]
	}
	
	static func analizi(
		arbon arbo: ArtikolNodo,
		indekso: String,
		lingvoj: [String: Lingvo],
		stiloj: [String: String]
	) -> Rezulto? {
		let stato = Stato(lingvoj: lingvoj, stiloj: stiloj)
		stato.artikolFabriko.indekso = indekso
		
		stato.artikolFabriko.blokoj = trakti(arbon: arbo, stato: stato)
		
		return rezulto(stato: stato)
	}
	
	static func trakti(arbon arbo: ArtikolNodo, stato: Stato) -> [ArtikolBloko] {
		assert(arbo.filoj.count == 1, "Tro da filoj en arboradiko")
		let filo = arbo.filoj.first!
		switch filo.tipo {
		case .vortaro:
			return trakti(vortaron: filo, stato: stato)
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	/// La finaj rezultoj de la artikol-traktado
	static func rezulto(stato: Stato) -> Rezulto? {
		guard let artikolo = stato.artikolFabriko.fabriki() else {
			return nil
		}
		
		return Rezulto(
			artikolo: artikolo,
			serchTradukoj: stato.serchTradukoj,
			serchVortoj: stato.serchVortoj,
			fakVortoj: stato.fakVortoj,
			ofcVortoj: stato.ofcVortoj,
			markSencoj: stato.markSencoj
		)
	}
	
	// MARK: - Nodspecoj
	
	/// Akumulas tekston el teksto-nodoj, kaj alispecaj nodoj kiuj enhavas nur tekstojn
	static func akumuliTekstojn(de nodo: ArtikolNodo, stato: Stato) -> String {
		var teksto = ""
		traktiFilojn(de: nodo, stato: stato) { filo in
			switch filo.tipo {
			case .aut:
				teksto += trakti(autoron: filo, stato: stato)
			case .ctl:
				teksto += trakti(citilon: filo, stato: stato)
			case .ekz:
				teksto += trakti(ekzemplon: filo, stila: false, stato: stato)
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
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .vspec:
				teksto += trakti(vortSpecon: filo, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto
	}
	
	static func traktiFilojn(de nodo: ArtikolNodo, stato: Stato, farotajh: (ArtikolNodo) -> Void) {
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
}
