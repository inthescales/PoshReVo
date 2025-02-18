extension ArboAnalizilo {
	static func trakti(kursivon kursivajho: ArtikolNodo, stato: Stato) -> String {
		// En la retejo, kursiva teksto aperas en tiparo "TeX-math"
		return akumuliTekstojn(de: kursivajho, stato: stato)
	}
}
