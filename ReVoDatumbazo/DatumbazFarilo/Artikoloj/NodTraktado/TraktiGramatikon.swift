extension ArboAnalizilo {
	static func trakti(gramatikon gramatiko: ArtikolNodo, stato: Stato) -> String {
		let filTeksto = akumuliTekstojn(de: gramatiko, stato: stato)
		return "<k>\(filTeksto)</k>\n\n"
	}
}
