extension ArboAnalizilo {
	static func trakti(URLon url: ArtikolNodo, referenco: String?, stato: TraktadoStato) -> String {
		// TODO: Trakti url-bazojn en grundo/dtd/vokourl.dtd / jsc/x/voko_entities.ts
		// TODO: Aldoni simbolon ekz. en ankaŭ
		let filTeksto = akumuliTekstojn(de: url, stato: stato)
		
		if let referenco = referenco {
			return "<a href=\(referenco)>" + filTeksto + "</a>"
		} else {
			return "<a href=\"\(filTeksto)\">\(filTeksto)</a>"
		}
	}
}
