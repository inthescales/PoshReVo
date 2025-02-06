extension ArboAnalizilo {
	static func trakti(trastrekitan: ArtikolNodo, stato: TraktadoStato) -> String {
		let filTeksto = traktiFilojn(de: trastrekitan, stato: stato)
		return "<del>" + filTeksto + "</del>"
	}
}
