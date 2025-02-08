extension ArboAnalizilo {
	static func trakti(gramatikon gramatiko: ArtikolNodo, stato: TraktadoStato) -> String {
		let filTeksto = akumuliTekstojn(de: gramatiko, stato: stato)
		return "(\(filTeksto))\n"
	}
}
