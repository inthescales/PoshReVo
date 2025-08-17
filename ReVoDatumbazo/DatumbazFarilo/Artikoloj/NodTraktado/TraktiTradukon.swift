extension ArboAnalizilo {
	/// Doni ĝustan tekston al tradukoj necesigas produkti kelkajn versiojn de la teksto.
	enum TradukTekstTipo {
		case artikolTeksta  // Teksto kiu aperu rekte en artikolteksto (difinoj ks.)
		case artikolTraduka	// Teksto kiu aperu en artikolaj tradukoj
		case sercha		    // Teksto kiun oni devos tajpi serĉe
		case videbla	    // Teksto kiu aperu en serĉrezultoj
	}
	
	/// Traktas traduk-elementon, aldonante tradukon kaj al artikolo kaj listo da serĉtradukoj.
	/// - transpasIndekso: indikas ke antaŭa indeks-elemento (<ind>) donas esperantajn tekstojn al tradukoj
	static func trakti(
		tradukon traduko: ArtikolNodo,
		lingvo: String,
		transpasIndekso: IndeksRezulto? = nil,
		stato: Stato
	) -> String? {
		guard let marko = stato.marko else {
			return nil
		}
		
		let tradukTeksto = kunigiTradukTekstojn(de: traduko, tipo: .artikolTraduka, stato: stato)
		
		let serchTeksto: String
		let rezultTeksto: String
		if tradukoKomplikas(traduko) {
			serchTeksto = kunigiTradukTekstojn(de: traduko, tipo: .sercha, stato: stato)
			rezultTeksto = kunigiTradukTekstojn(de: traduko, tipo: .videbla, stato: stato)
		} else {
			serchTeksto = tradukTeksto
			rezultTeksto = tradukTeksto
		}
		
		if let artikolIndekso = stato.artikolIndekso {
			
			let artikolTraduko = ArtikolTraduko(
				apartaNomo: transpasIndekso?.tradukTeksto,
				teksto: tradukTeksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco
			)
			stato.aldoni(derivajhTradukon: artikolTraduko, lingvo: lingvo)
				
			// Ni aldonu apartan serĉtradukon por ĉiu formo de la derivaĵo
			// vd. premdevigi / premnecesigi / premtrudi – unu derivaĵo, unu traduko en artikolo,
			// tri malsamaj serĉrezulteroj
			for derivajhNomo in stato.derivajhFormoj {
				let serchTraduko = SerchTraduko(
					serchTeksto: serchTeksto,
					videblaTeksto: rezultTeksto,
					esperantaNomo: transpasIndekso?.serchTeksto ?? derivajhNomo,
					indekso: artikolIndekso,
					marko: marko,
					senco: stato.nunaSenco
				)
				stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
			}
		}
		
		return kunigiTradukTekstojn(de: traduko, tipo: .artikolTeksta, stato: stato)
	}
	
	/// Liveras 'true' se necesos plurforma traduk-teksto
	fileprivate static func tradukoKomplikas(_ traduko: ArtikolNodo) -> Bool {
		return traduko.filoj.contains { filo in
			switch filo.tipo {
			case .ind, .klr, .mll, .pr:
				return true
			default:
				break
			}
			
			return false
		}
	}
	
	/// Liveras traduk-tekston de certa tipo
	fileprivate static func kunigiTradukTekstojn(
		de traduko: ArtikolNodo,
		tipo: TradukTekstTipo,
		stato: Stato
	) -> String {
		var teksto = ""
		var finis = false
		
		traktiFilojn(de: traduko, stato: stato) { filo in
			guard !finis else {
				return
			}
			
			switch filo.tipo {
			case .baz, .ofc:
				break
			case .ind:
				let rezulto = trakti(indekson: filo, stato: stato)
				switch tipo {
				case .artikolTeksta, .artikolTraduka, .videbla:
					teksto += rezulto.teksto
				case .sercha:
					teksto = rezulto.serchTeksto
					finis = true
				}
			case .klr:
				let filTeksto = trakti(klarigon: filo, stato: stato)
				switch tipo {
				case .artikolTeksta, .artikolTraduka, .videbla:
					teksto += filTeksto
				case .sercha:
					break
				}
			case .mll(let mllTipo):
				let filTeksto = trakti(mallongigon: filo, stato: stato).teksto
				switch tipo {
				case .artikolTeksta, .artikolTraduka:
					teksto += filTeksto
				case .sercha:
					teksto = filTeksto
					finis = true
				case .videbla:
					teksto = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: mllTipo)
					finis = true
				}
			case .pr:
				switch tipo {
				case .artikolTraduka:
					teksto += trakti(prononcon: filo, stato: stato)
				case .artikolTeksta, .sercha, .videbla:
					break
				}
			case .teksto(let filTeksto):
				switch tipo {
				case .artikolTeksta:
					// Tradukoj ene de artikolaj tradukoj aperu kursive (ekz. sciencaj nomoj de bestoj kaj plantoj)
					// Tamen, filnodoj de tradukoj, laŭ mia kono, ne estu kursivaj. Ekz. en artikolo 'om/o'
					// troviĝas "<i>Ohm </i>(Georg Simon)<i></i>, (klr ene de trd)
					teksto += TekstAtributo.volvi(filTeksto, per: .kursiva)
				default:
					teksto += filTeksto
				}
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto.prepari().kunpremi().tondi()
	}
}
