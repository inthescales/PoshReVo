extension ArboAnalizilo {
	static func trakti(prononcon prononco: ArtikolNodo, stato: Stato) -> String {
		return "[" + akumuliTekstojn(de: prononco, stato: stato) + "]"
	}
}
