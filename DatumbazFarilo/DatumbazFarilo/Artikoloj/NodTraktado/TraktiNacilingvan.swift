extension ArboAnalizilo {
	static func trakti(nacilingvan nacilingvajho: ArtikolNodo, stato: TraktadoStato) -> String {
		return akumuliTekstojn(de: nacilingvajho, stato: stato)
	}
}
