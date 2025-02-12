extension ArboAnalizilo {
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
		
		// Tuta teksto de traduk-elemento
		var teksto = ""
		
		// Vorto kiun oni devos tajpi, se malsamas ol kompleta teksto
		var serchTeksto: String?
		
		// Mallonga formo de serĉteksto, se malsamas ol kompleta teksto
		var videblaTeksto: String?
		
	
		traktiFilojn(de: traduko, stato: stato) { filo in
			let filTeksto: String
			switch filo.tipo {
			case .baz, .ofc:
				filTeksto = ""
			case .ind:
				let rezulto = trakti(indekson: filo, stato: stato)
				filTeksto = rezulto.teksto
				serchTeksto = rezulto.serchTeksto
			case .klr(_):
				serchTeksto = teksto
				filTeksto = trakti(klarigon: filo, stato: stato)
			case .mll(let tipo):
				filTeksto = trakti(mallongigon: filo, stato: stato).teksto
				videblaTeksto = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
				serchTeksto = filTeksto
			case .pr:
				filTeksto = trakti(prononcon: filo, stato: stato)
			case .teksto(let tekstEnhavoj):
				filTeksto = tekstEnhavoj
			default:
				assert(false, "Neatendita filo")
				filTeksto = ""
			}
			
			teksto += filTeksto
		}
		
		teksto = teksto.prepari().kunpremi().tondi()
		
		if let derivajhNomo = stato.derivajhNomo,
		   let derivajhTildo = stato.derivajhTildo,
		   let artikolIndekso = stato.artikolIndekso {
			
			let artikolTraduko = ArtikolTraduko(
				nomo: transpasIndekso?.tradukTeksto ?? derivajhTildo,
				teksto: teksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco,
				transpasNomo: transpasIndekso != nil
			)
			stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
			
			let serchTraduko = SerchTraduko(
				serchTeksto: serchTeksto ?? teksto,
				videblaTeksto: videblaTeksto ?? teksto,
				esperantaNomo: transpasIndekso?.serchTeksto ?? derivajhNomo,
				indekso: artikolIndekso,
				marko: marko,
				senco: stato.nunaSenco
			)
			stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
		}
	}
}
