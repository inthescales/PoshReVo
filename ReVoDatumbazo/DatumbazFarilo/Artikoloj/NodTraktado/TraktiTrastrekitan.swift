extension ArboAnalizilo {
	static func trakti(trastrekitan: ArtikolNodo, stato: Stato) -> String {
		// TODO: Ĉu ĉi tio funkcias? Trovu ekzemplon
		return "<del>" + akumuliTekstojn(de: trastrekitan, stato: stato) + "</del>"
	}
}
