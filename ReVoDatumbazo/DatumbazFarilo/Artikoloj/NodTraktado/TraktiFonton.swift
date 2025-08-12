extension ArboAnalizilo {
	// MARK: - Traktado
	
	/// Traktas fontnodon. Liveras tekston kiu aperu en artikolteksto.
	static func trakti(fonton fonto: ArtikolNodo, stato: Stato) -> String {
		// NOTO:
		// En la retejo, <fnt> etikedoj aldonas fonton al la koncerna derivaĵo aŭ artikolo,
		// kaj metas fontindikon (ekz. '[1]') alklakeblan, kondukante al fontinformaj piednotoj.
		// Ĝis nun en ĉi tiu apo, fontoj estas plejparte ignorataj, krom en <rim>-oj kie tiuj
		// fontoj aperantaj en la bibliografio (kaj havante <bib>-etikedon) aperos en tekstoj
		// Ĉi-metodo traktas tiujn videblajn fontojn. La aliajn kazojn traktas la 'ignori...'
		// metodoj subaj.
		
		/// Teksto aperanta en <bib>, se estas
		var bibTeksto: String? = nil
		
		/// Ĉu <lok> aperas en la fonto
		var havasLokon = false
		
		for filo in fonto.filoj {
			switch filo.tipo {
			case .aut:
				// TODO: fontoj - aldoni metodon trakti(autoron:)
				break
			case .bib:
				// TODO: fontoj - ligilo al bibliografio, aŭ montri klarigon super artikolo
				bibTeksto = akumuliTekstojn(de: filo, stato: stato)
			case .lok:
				// TODO: fontoj - aldoni metodon trakti(lokon:)
				havasLokon = true
			case .teksto(_):
				break
			case .vrk:
				// TODO: fontoj - aldoni metodon trakti(verkon:) - notu ke tio enhavos <url>ojn
				break
			case .url(_):
				break
			default:
				assert(false, "neatendita filo")
			}
		}
		
		// TODO: fontoj - aldoni fonton al stato
		
		if let bibTeksto,
		   !bibTeksto.isEmpty && !havasLokon {		
			return bibTeksto
		} else {
			// TODO: fontoj
			// Ĝis kiam la apo havos kapablon montri liston da fontoj en artikolo,
			// ne indas meto fontnumeron (e.g. '[1]' ks.). Espereble ne estos tro
			// konfuza nur indiki ke io mankas
			return "..."
		}
	}
	
	// MARK: - Ignorado
	
	/// Multaj nodoj nuntempe ne montras fontindikojn kiuj aperas en la retejo. Tamen, tiuj fnt-etikedoj estas ĉirkaŭitaj de tekstaj
	/// spacoj kaj novaj linioj, kiuj devos esti fortonditaj.
	static func ignoriFonton(teksto: String, stato: Stato) -> String {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			return teksto
		default:
			return teksto.tondi()
		}
	}
	
	/// Multaj nodoj nuntempe ne montras fontindikojn kiuj aperas en la retejo. Tamen, tiuj fnt-etikedoj estas ĉirkaŭitaj de tekstaj
	/// spacoj kaj novaj linioj, kiuj devos esti fortonditaj.
	static func ignoriFonton(akumulilo: BlokAkumulilo, stato: Stato) {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			break
		default:
			akumulilo.tondiTekston()
		}
	}
}
