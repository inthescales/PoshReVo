extension ArboAnalizilo {
	static func trakti(nomon nomo: ArtikolNodo, stato: TraktadoStato) -> String {
		return akumuliTekstojn(de: nomo, stato: stato)
	}
}
