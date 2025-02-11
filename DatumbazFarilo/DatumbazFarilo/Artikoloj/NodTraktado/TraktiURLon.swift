extension ArboAnalizilo {
	static func trakti(URLon url: ArtikolNodo, referenco: String?, stato: TraktadoStato) -> String {
		let filTeksto = akumuliTekstojn(de: url, stato: stato)
		
		if let referenco = referenco {
			return "<a href=\(referenco)>" + filTeksto + "</a>"
		} else {
			return "<a href=\"\(filTeksto)\">\(filTeksto)</a>"
		}
	}
}
