extension ArboAnalizilo {
	static func trakti(kursivon kursivajho: ArtikolNodo, stato: TraktadoStato) -> String {
		// En la retejo, kursiva teksto aperas en tiparo "TeX-math"
		return akumuliTekstojn(de: kursivajho, stato: stato)
	}
}
