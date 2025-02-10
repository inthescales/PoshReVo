extension ArboAnalizilo {
	static func trakti(escepton escepto: ArtikolNodo, stato: TraktadoStato) -> String {
		return akumuliTekstojn(de: escepto, stato: stato)
	}
}
