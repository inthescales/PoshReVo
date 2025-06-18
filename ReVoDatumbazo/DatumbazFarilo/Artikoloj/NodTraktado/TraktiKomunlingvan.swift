extension ArboAnalizilo {
	static func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: Stato) -> String {
		return TekstoAtributo.volvi(
			tekston: akumuliTekstojn(de: komunlingvajho, stato: stato),
			per: .kursiva
		)
	}
}
