extension ArboAnalizilo {
	static func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: Stato) -> String {
		return TekstAtributo.volvi(
			akumuliTekstojn(de: komunlingvajho, stato: stato),
			per: .kursiva
		)
	}
}
