extension ArboAnalizilo {
	static func traktiFonton(akumulilo: BlokAkumulilo, stato: Stato) {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			break
		default:
			akumulilo.tondiTekston()
		}
	}
	
	/// Traktas fontnodon. Liveras tekston kiu aperu en artikolteksto, kaj aldonas plenan fontinformojn al la stato.
	static func trakti(fonton fonto: ArtikolNodo, stato: Stato) -> String {
		/// Teksto aperanta en <bib>, se estas
		var bibTeksto: String? = nil
		
		/// Teksto kiu aperos en fontolisto, ne tio kio aperos en artikolo
		var fontoTeksto = ""
		
		/// Ĉu <lok> aperas en la fonto
		var havasLokon = false
		
		for filo in fonto.filoj {
			switch filo.tipo {
			case .aut:
				// TODO: fontoj - aldoni metodon trakti(autoron:)
				fontoTeksto += akumuliTekstojn(de: filo, stato: stato)
			case .bib:
				// En retejo, teksto ligas al bibliografio
				let filteksto = trakti(bibliografiajhon: filo, stato: stato)
				fontoTeksto += filteksto
				bibTeksto = filteksto
			case .lok:
				// TODO: fontoj - aldoni metodon trakti(lokon:)
				fontoTeksto += akumuliTekstojn(de: filo, stato: stato)
				havasLokon = true
			case .teksto(let filteksto):
				fontoTeksto += filteksto
			case .vrk:
				// TODO: fontoj - aldoni metodon trakti(verkon:) - notu ke tio enhavos <url>ojn
				fontoTeksto += akumuliTekstojn(de: filo, stato: stato)
			case .url(let ref):
				fontoTeksto += trakti(URLon: filo, referenco: ref, stato: stato)
			default:
				assert(false, "neatendita filo")
			}
		}
		
		// TODO: fontoj - aldoni fonton al stato
		
		if let bibTeksto,
		   !bibTeksto.isEmpty && !havasLokon {
			// TODO: fontoj
			// Uzu bibliografian tekston nur post kiam disponeblas liston da bibliografiaĵoj
			// inter mallongigolistoj
		
			return "..."
		} else {
			// TODO: fontoj
			// Ĝis kiam la apo havos kapablon montri liston da fontoj en artikolo,
			// ne indas meto fontnumeron (e.g. '[1]' ks.). Espereble ne estos tro
			// konfuza nur indiki ke io mankas
			return "..."
		}
	}
	
	/// Multaj nodoj ne montras la tekstojn de siaj enhavataj filoj. Tamen, tiuj fnt-etikedoj estas ĉirkaŭitaj de tekstaj
	/// spacoj kaj novaj linioj, kiuj devos esti forigitaj.
	static func trapasiFonton(teksto: String, stato: Stato) -> String {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			return teksto
		default:
			return teksto.tondi()
		}
	}
}
