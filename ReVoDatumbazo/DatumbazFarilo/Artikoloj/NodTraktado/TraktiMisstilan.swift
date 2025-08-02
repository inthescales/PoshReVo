extension ArboAnalizilo {
	static func trakti(misstilan misstilajho: ArtikolNodo, stato: Stato) -> String {
		return TekstAtributo.volvi("x", per: .supera) + akumuliTekstojn(de: misstilajho, stato: stato)
	}
}
