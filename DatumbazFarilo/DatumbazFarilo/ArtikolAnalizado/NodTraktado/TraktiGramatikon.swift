extension ArboAnalizilo {
	static func trakti(gramatikon gramatiko: ArtikolNodo, stato: TraktadoStato) -> String {
		let filTeksto = traktiFilojn(de: gramatiko, stato: stato)
		
		return "(\(filTeksto))\n"
	}
}
