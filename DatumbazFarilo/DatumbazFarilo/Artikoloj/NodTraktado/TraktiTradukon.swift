extension ArboAnalizilo {
	static func trakti(
		tradukon traduko: ArtikolNodo,
		lingvo: String,
		transpasIndekso: IndeksRezulto? = nil,
		stato: TraktadoStato
	) {
		guard let marko = stato.marko else {
			return
		}
		
		var serchNomo: String? // Vorto tajpenda en serĉo
		var mallongaNomo: String? // Mallonga formo de serĉteksto
		var teksto = ""
		
		traktiFilojn(de: traduko, stato: stato) { filo in
			let filTeksto: String
			switch filo.tipo {
			case .baz, .ofc:
				filTeksto = ""
			case .ind:
				let rezulto = trakti(indekson: filo, stato: stato)
				filTeksto = rezulto.teksto
				serchNomo = rezulto.serchTeksto ?? rezulto.teksto
			case .klr(_):
				filTeksto = trakti(klarigon: filo, stato: stato)
				serchNomo = teksto
			case .mll(let tipo):
				filTeksto = trakti(mallongigon: filo, stato: stato).teksto
				mallongaNomo = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
				serchNomo = filTeksto
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
		
		if let nomo = stato.derivajhNomo,
		   let tildo = stato.derivajhTildo,
		   let indekso = stato.artikolIndekso {
			
			let artikolTraduko = ArtikolTraduko(
				nomo: transpasIndekso?.tradukTeksto ?? transpasIndekso?.tildTeksto ?? tildo,
				teksto: teksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco,
				transpasNomo: transpasIndekso != nil
			)
			stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
			
			let serchTraduko = SerchTraduko(
				serchTeksto: serchNomo ?? teksto,
				videblaTeksto: mallongaNomo ?? teksto,
				esperantaNomo: transpasIndekso?.serchTeksto ?? nomo,
				indekso: indekso,
				marko: marko,
				senco: stato.nunaSenco
			)
			stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
		}
	}
}
