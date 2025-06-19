extension ArboAnalizilo {
	static func trakti(misstilan misstilajho: ArtikolNodo, stato: Stato) -> String {
		return TekstAtributo.volvi(tekston: "x", per: .supera) + akumuliTekstojn(de: misstilajho, stato: stato)
	}
}
