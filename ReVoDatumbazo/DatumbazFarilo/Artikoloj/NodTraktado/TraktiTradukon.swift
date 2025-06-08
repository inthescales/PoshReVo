extension ArboAnalizilo {
	/// Doni ĝustan tekston al tradukoj necesigas produkti kelkajn versiojn de la teksto.
	enum TradukTekstTipo {
		case artikola	// Teksto kiu aperu en tradukoj ene de artikolo
		case sercha		// Teksto kiun oni devos tajpi serĉe
		case videbla	// Teksto kiu aperu en serĉrezultoj
	}
	
	/// Traktas traduk-elementon, aldonante tradukon kaj al artikolo kaj listo da serĉtradukoj.
	/// - transpasIndekso: indikas ke antaŭa indeks-elemento (<ind>) donas esperantajn tekstojn al tradukoj
	static func trakti(
		tradukon traduko: ArtikolNodo,
		lingvo: String,
		transpasIndekso: IndeksRezulto? = nil,
		stato: Stato
	) {
		guard let marko = stato.marko else {
			return
		}
		
		let artikolTeksto = kunigiTradukTekstojn(de: traduko, tipo: .artikola, stato: stato)
		
		let serchTeksto: String
		let videblaTeksto: String
		if tradukoKomplikas(traduko) {
			serchTeksto = kunigiTradukTekstojn(de: traduko, tipo: .sercha, stato: stato)
			videblaTeksto = kunigiTradukTekstojn(de: traduko, tipo: .videbla, stato: stato)
		} else {
			serchTeksto = artikolTeksto
			videblaTeksto = artikolTeksto
		}
		
		if let derivajhNomo = stato.derivajhNomo,
		   let derivajhTildo = stato.derivajhTildo,
		   let artikolIndekso = stato.artikolIndekso {
			
			let artikolTraduko = ArtikolTraduko(
				nomo: transpasIndekso?.tradukTeksto ?? derivajhTildo,
				teksto: artikolTeksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco,
				transpasNomo: transpasIndekso != nil
			)
			stato.aldoni(derivajhTradukon: artikolTraduko, lingvo: lingvo)
			
			let serchTraduko = SerchTraduko(
				serchTeksto: serchTeksto,
				videblaTeksto: videblaTeksto,
				esperantaNomo: transpasIndekso?.serchTeksto ?? derivajhNomo,
				indekso: artikolIndekso,
				marko: marko,
				senco: stato.nunaSenco
			)
			stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
		}
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
				case .artikola, .videbla:
					teksto += rezulto.teksto
				case .sercha:
					teksto = rezulto.serchTeksto
					finis = true
				}
			case .klr:
				let filTeksto = trakti(klarigon: filo, stato: stato)
				switch tipo {
				case .artikola, .videbla:
					teksto += filTeksto
				case .sercha:
					break
				}
			case .mll(let mllTipo):
				let filTeksto = trakti(mallongigon: filo, stato: stato).teksto
				switch tipo {
				case .artikola:
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
				case .artikola:
					teksto += trakti(prononcon: filo, stato: stato)
				case .sercha, .videbla:
					break
				}
			case .teksto(let filTeksto):
				teksto += filTeksto
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto.prepari().kunpremi().tondi()
	}
}
