extension ArboAnalizilo {
	static func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: TraktadoStato) -> String {
		return "<i>" + akumuliTekstojn(de: komunlingvajho, stato: stato) + "</i>"
	}
}
