extension ArboAnalizilo {
	static func trakti(komunlingvan komunlingvajho: ArtikolNodo, stato: TraktadoStato) -> String {
		return "<i>" + traktiFilojn(de: komunlingvajho, stato: stato) + "</i>"
	}
}
