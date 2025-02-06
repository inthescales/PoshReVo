extension ArboAnalizilo {
	static func trakti(misstilan misstilajho: ArtikolNodo, stato: TraktadoStato) -> String {
		let filTeksto = traktiFilojn(de: misstilajho, stato: stato)
		return "<sup>x</sup>" + filTeksto
	}
}
