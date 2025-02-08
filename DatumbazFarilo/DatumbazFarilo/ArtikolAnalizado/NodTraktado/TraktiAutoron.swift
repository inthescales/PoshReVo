extension ArboAnalizilo {
	static func trakti(autoron autoro: ArtikolNodo, stato: TraktadoStato) -> String {
		// Ĉi nodo plej ofte aperas en <fnt>.
		// Vidu 'sude de' por kontraŭa ekzemplo.
		return "[" + akumuliTekstojn(de: autoro, stato: stato) + "]"
	}
}
