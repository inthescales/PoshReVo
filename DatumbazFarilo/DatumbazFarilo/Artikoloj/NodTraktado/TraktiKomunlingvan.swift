extension ArboAnalizilo {
	static func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: Stato) -> String {
		return "<i>" + akumuliTekstojn(de: komunlingvajho, stato: stato) + "</i>"
	}
}
