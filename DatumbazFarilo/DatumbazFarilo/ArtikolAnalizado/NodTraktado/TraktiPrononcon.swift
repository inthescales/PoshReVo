extension ArboAnalizilo {
	static func trakti(prononcon prononco: ArtikolNodo, stato: TraktadoStato) -> String {
		let teksto = traktiFilojn(de: prononco, stato: stato)
		return "[" + teksto + "]"
	}
}
