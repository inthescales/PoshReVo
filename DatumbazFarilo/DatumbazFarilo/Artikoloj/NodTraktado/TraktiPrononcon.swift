extension ArboAnalizilo {
	static func trakti(prononcon prononco: ArtikolNodo, stato: TraktadoStato) -> String {
		return "[" + akumuliTekstojn(de: prononco, stato: stato) + "]"
	}
}
