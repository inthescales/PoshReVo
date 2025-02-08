extension ArboAnalizilo {
	static func trakti(trastrekitan: ArtikolNodo, stato: TraktadoStato) -> String {
		return "<del>" + akumuliTekstojn(de: trastrekitan, stato: stato) + "</del>"
	}
}
