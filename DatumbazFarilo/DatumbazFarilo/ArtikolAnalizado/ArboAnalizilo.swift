import ReVoModelojOSX

enum ArboAnalizilo {
	/// Rezulto de analizo de artikol-dokumento.
	struct Rezulto {
		/// Ĉiuj datumoj per kiu artikolo estos prezentata
		let artikolo: Artikolo
		
		/// Tradukoj kiuj estos serĉeblaj
		let serchTradukoj: [String: [SerchTraduko]]
		
		/// Markoj kaj siaj kunligitaj sencoj
		let markSencoj: [String: Int]
	}
	
	static func analizi(
		arbon arbo: ArtikolNodo,
		indekso: String,
		lingvoj: [String: Lingvo],
		stiloj: [String: String]
	) -> Rezulto? {
		let stato = TraktadoStato(stiloj: stiloj)
		stato.artikolFabriko.indekso = indekso
		
		trakti(arbon: arbo, stato: stato)
		
		return rezulto(stato: stato, lingvoj: lingvoj)
	}
	
	static func trakti(arbon arbo: ArtikolNodo, stato: TraktadoStato) {
		assert(arbo.filoj.count == 1, "Tro da filoj en arboradiko")
		let filo = arbo.filoj.first!
		switch filo.tipo {
		case .vortaro:
			trakti(vortaron: filo, stato: stato)
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	/// La finaj rezultoj de la artikol-traktado
	static func rezulto(stato: TraktadoStato, lingvoj: [String: Lingvo]) -> Rezulto? {
		guard let artikolo = stato.artikolFabriko.fabriki(lingvoj: lingvoj) else {
			return nil
		}
		
		return Rezulto(
			artikolo: artikolo,
			serchTradukoj: stato.serchTradukoj,
			markSencoj: stato.markSencoj
		)
	}
	
	// MARK: - Nodspecoj
	
	/// Akumulas tekston el teksto-nodoj, kaj alispecaj nodoj kiuj enhavas nur tekstojn
	static func akumuliTekstojn(de nodo: ArtikolNodo, stato: TraktadoStato) -> String {
		var teksto = ""
		traktiFilojn(de: nodo, stato: stato) { filo in
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
				teksto = teksto.tondi()
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
				trakti(tradukon: filo, lingvo: lng!, stato: stato)
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
	
	static func trakti(nodon nodo: ArtikolNodo, stato: TraktadoStato, ampligiTildojn: Bool = true) -> String? {
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
			//	case .ind:
			//		return trakti(indekson: nodo, stato: stato)
		case .k:
			return trakti(kursivon: nodo, stato: stato)
		case .kap:
			_ = trakti(kapon: nodo, stato: stato)
		case .ke:
			return trakti(komunlingvan: nodo, stato: stato)
		case .klr(_):
			return trakti(klarigon: nodo, stato: stato)
		case .lstref(let lst):
			return trakti(listReferencon: nodo, listo: lst, stato: stato)
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
			assert(false, "Subderivaĵo nur aperu ene de derivaĵo")
			return nil
		case .subsnc(let mrk):
			return trakti(subsencon: nodo, marko: mrk, stato: stato)
		case .sup:
			return trakti(altigitan: nodo, stato: stato)
		case .teksto(let teksto):
			return teksto.prepari()
		case .tezrad:
			break
		case .tld(let lit, let vari):
			if ampligiTildojn {
				return traktiTildon(stato: stato, litero: lit, variajho: vari)
			} else {
				return "~"
			}
		case .ts:
			return trakti(trastrekitan: nodo, stato: stato)
		case .trd(let lng):
			// Traktas sendependajn tradukojn. Tiuj ene de 'trdgrp' estos traktataj
			// ene de `trakti(tradukGrupon:...)`
			if let lingvo = lng {
				_ = trakti(tradukon: nodo, lingvo: lingvo, stato: stato)
			}
			return nil
		case .trdgrp(let lng):
			trakti(tradukGrupon: nodo, lingvo: lng, stato: stato)
			return nil
		case .url(let ref):
			return trakti(URLon: nodo, referenco: ref, stato: stato)
		case .uzo(let tip):
			return trakti(uzon: nodo, tipo: tip, stato: stato)
		case .vari:
			_ = trakti(variajhon: nodo, stato: stato)
		case .vspec:
			return trakti(vortSpecon: nodo, stato: stato)
		case .adm, .aut, .baz, .bib, .bld, .fnt, .lok, .mrk, .vrk:
			break
		case .ind, .mll, .vortaro:
			// Teorie, ĉiuj elementoj prefere estus nur menciita en kazoj je kiu ni scias
			// ke ili povas aperi laŭ manlibro. Intertempe, mi nur aŭdacas tiel trakti kelkajn.
			assert(false, "Elemento nur aperu en difinitaj lokoj")
			break
		}
		
		return nil
	}
	
	static func traktiFilojn(de nodo: ArtikolNodo, stato: TraktadoStato, ampligiTildojn: Bool = true) -> String {
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
	
	static func traktiFilojn(de nodo: ArtikolNodo, stato: TraktadoStato, farotajh: (ArtikolNodo) -> Void) {
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
// ATENTU
// En 'provludi' - tradukoj ekzistas por 'prov~o', kiu NE APERAS KIEL DERIVAĴO
