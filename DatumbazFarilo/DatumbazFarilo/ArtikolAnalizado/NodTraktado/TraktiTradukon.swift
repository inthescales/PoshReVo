extension ArboAnalizilo {
	static func trakti(tradukon traduko: ArtikolNodo, lingvo: String, stato: TraktadoStato) {
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
				filTeksto = rezulto.0
				serchNomo = rezulto.1
			case .klr(_):
				filTeksto = trakti(klarigon: filo, stato: stato)
			case .mll(let tipo):
				filTeksto = trakti(nodon: filo, stato: stato) ?? ""
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
		
		if false {
			// TODO: Tradukoj en ekzemploj
			//		let artikolTraduko = ArtikolTraduko(
			//			nomo: indekso,
			//			teksto: teksto,
			//			marko: marko,
			//			senco: stato.sncNombro
			//		)
			//		stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
		} else if let nomo = stato.derivajhNomo,
				  let tildo = stato.derivajhTildo,
				  let indekso = stato.artikolIndekso {
			let artikolTraduko = ArtikolTraduko(
				nomo: tildo,
				teksto: teksto,
				marko: marko,
				senco: stato.nunaSenco,
				subsenco: stato.nunaSubsenco
			)
			stato.aldoni(artikolTradukon: artikolTraduko, lingvo: lingvo)
			
			let serchTraduko = SerchTraduko(
				videblaNomo: serchNomo ?? teksto,
				nomo: nomo,
				teksto: teksto,
				indekso: indekso,
				marko: marko,
				senco: stato.nunaSenco
			)
			stato.aldoni(serchTradukon: serchTraduko, lingvo: lingvo)
		}
	}
}
