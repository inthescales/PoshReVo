extension ArboAnalizilo {
	static func trakti(misstilan misstilajho: ArtikolNodo, stato: Stato) -> String {
		return "<sup>x</sup>" + akumuliTekstojn(de: misstilajho, stato: stato)
	}
}
