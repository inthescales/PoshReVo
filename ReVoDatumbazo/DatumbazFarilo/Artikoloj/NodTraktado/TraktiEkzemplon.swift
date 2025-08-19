extension ArboAnalizilo {
	/// Kian stilon ekzemploj en la artikolo havu
	enum EkzemploStilo {
		/// Ĉiuj stilaĵoj uziĝu — uzata ĉe ekzemplolistoj
		case plena
		
		/// Nur kursiva teksto aperu — uzata ekz. ene de rimarkoj
		case kursiva
		
		/// Atributoj aldonindaj tiustile, en la ordo laŭ kiu oni per ili volvu
		var atributoj: [TekstAtributo] {
			switch self {
			case .plena:
				return [.kursiva, .ekzemplo]
			case .kursiva:
				return [.kursiva]
			}
		}
	}
	
	static func trakti(
		ekzemplon ekzemplo: ArtikolNodo,
		stilo: EkzemploStilo = .plena,
		lista: Bool = true,
		stato: Stato
	) -> String {
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
				teksto = ignoriFonton(teksto: teksto, stato: stato)
			case .frm:
				let filTeksto = trakti(formulon: filo, stato: stato)
				teksto += TekstAtributo.malvolvi(filTeksto, per: .kursiva)
			case .ind:
				let indeksRezulto = trakti(indekson: filo, stato: stato)
				teksto += indeksRezulto.teksto
				indeksajho = indeksRezulto
			case .klr:
				let filTeksto = trakti(klarigon: filo, stato: stato)
				teksto += TekstAtributo.malvolvi(filTeksto, per: .kursiva)
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
		
		// Purige forigi malplenajn parojn
		teksto = TekstAtributo.forigi(el: teksto, malplenaj: .kursiva)
		
		if lista {
			return "\n" + volvi(" · " + teksto.kunpremi().tondi(), lau: stilo)
		} else {
			return volvi(teksto.kunpremi().tondi(), lau: stilo)
		}
	}
	
	// MARK: - Helpiloj
	
	/// Serie volvas la tekston per la atributoj de la stilo
	private static func volvi(_ teksto: String, lau stilo: EkzemploStilo) -> String {
		stilo.atributoj.reduce(teksto, { teksto, atributo in
			TekstAtributo.volvi(teksto, per: atributo)
		})
	}
}
