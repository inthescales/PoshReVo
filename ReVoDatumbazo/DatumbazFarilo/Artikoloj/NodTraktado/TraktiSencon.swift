extension ArboAnalizilo {
	static func trakti(
		sencon senco: ArtikolNodo,
		marko: String?,
		montriEtikedon: Bool,
		freshaLinio: Bool,
		stato: Stato
	) -> String {
		if stato.lastaSenco == nil {
			stato.lastaSenco = 0
		}
		
		stato.lastaSenco? += 1
		stato.nunaSenco = stato.lastaSenco
		
		if let marko = marko,
		   let senco = stato.nunaSenco {
			stato.markSencoj[marko] = (senco, nil)
		}
		
		var teksto = ""
		if montriEtikedon {
			teksto += sencEtikedo(numero: stato.nunaSenco ?? 0, freshaLinio: freshaLinio, stato: stato)
		} else {
			// Senco ĉiam aperu en nova linio post difino, sed ne aliaj (ekz. uzo).
			let lastaSibo = stato.sibStako.last
			let sekvasDifino = { switch lastaSibo { case .dif: return true; default: return false; } }()
			if sekvasDifino {
				teksto += "\n"
			}
		}
		traktiFilojn(de: senco, stato: stato) { filo in
			switch filo.tipo {
			case .adm, .bld:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .ekz:
				teksto += trakti(ekzemplon: filo, freshaLinio: teksto.last == "\n" || freshaLinio, stato: stato)
			case .fnt:
				teksto = ignoriFonton(teksto: teksto, stato: stato)
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .kap:
				_ = trakti(kapon: filo, stato: stato)
			case .lstref(let lst):
				teksto += trakti(listReferencon: filo, listo: lst, stato: stato)
			case .mlg:
				teksto = ignoriKapanMallongigon(teksto: teksto, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .rim(let num):
				teksto += trakti(rimarkon: filo, numero: num, stato: stato)
			case .subsnc(let mrk):
				let filTeksto = trakti(subsencon: filo, marko: mrk, stato: stato)
				
				if let subsencNombro = stato.lastaSubsenco,
				   let litero = ArtikolTeksto.subsencLitero(por: subsencNombro) {
					teksto += "\n\n" + TekstAtributo.volvi(litero + ") ", per: .sencNumero)
				}
				teksto += filTeksto
			case .teksto, .tezrad:
				break
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
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
		
		// Eliras sencon
		stato.nunaSenco = nil
		stato.lastaSubsenco = nil
		
		return teksto
	}
	
	/// Liveras etikedtekston por senco laŭ ĝia numero kaj aliaj argumentoj
	private static func sencEtikedo(
		numero: Int,
		freshaLinio: Bool,
		stato: Stato
	) -> String {
		var prefikso: String?
		if numero > 1 || !freshaLinio {
			prefikso = "\n\n"
		}
		
		return (prefikso ?? "") + TekstAtributo.volvi(String(numero) + ". ", per: .sencNumero)
	}
}
