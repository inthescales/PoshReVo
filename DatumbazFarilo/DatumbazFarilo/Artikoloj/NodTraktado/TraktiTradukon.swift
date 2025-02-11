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
		
		var serchNomo: String?
		var teksto = ""
		
		traktiFilojn(de: traduko, stato: stato) { filo in
			let filTeksto: String
			switch filo.tipo {
			case .baz, .ofc:
				filTeksto = ""
			case .ind:
				let rezulto = trakti(indekson: filo, stato: stato)
				filTeksto = rezulto.teksto
				serchNomo = rezulto.serchTeksto
			case .klr(_):
				filTeksto = trakti(klarigon: filo, stato: stato)
			case .mll(let tipo):
				filTeksto = trakti(mallongigon: filo, stato: stato)
				serchNomo = ArtikolTeksto.mllTeksto(baza: filTeksto, tipo: tipo)
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
				nomo: transpasIndekso?.tildTeksto ?? tildo,
				teksto: teksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco,
				transpasNomo: transpasIndekso != nil
			)
			stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
			
			let serchTraduko = SerchTraduko(
				videblaTeksto: serchNomo ?? teksto,
				nomo: transpasIndekso?.teksto ?? nomo,
				teksto: teksto,
				indekso: indekso,
				marko: marko,
				senco: stato.nunaSenco
			)
			stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
		}
	}
}
