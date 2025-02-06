extension ArboAnalizilo {
	static func trakti(kursivon kursivajho: ArtikolNodo, stato: TraktadoStato) -> String {
		// En la retejo, kursiva teksto aperas en tiparo "TeX-math"
		return traktiFilojn(de: kursivajho, stato: stato)
	}
}
