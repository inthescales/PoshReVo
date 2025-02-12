extension ArboAnalizilo {
	static func trakti(trastrekitan: ArtikolNodo, stato: Stato) -> String {
		return "<del>" + akumuliTekstojn(de: trastrekitan, stato: stato) + "</del>"
	}
}
