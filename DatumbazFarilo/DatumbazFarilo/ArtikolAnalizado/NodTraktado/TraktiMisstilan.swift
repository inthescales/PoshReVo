extension ArboAnalizilo {
	static func trakti(misstilan misstilajho: ArtikolNodo, stato: TraktadoStato) -> String {
		return "<sup>x</sup>" + akumuliTekstojn(de: misstilajho, stato: stato)
	}
}
