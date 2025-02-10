extension ArboAnalizilo {
	static func trakti(grasan grasajho: ArtikolNodo, stato: TraktadoStato) -> String {
		let filTeksto = akumuliTekstojn(de: grasajho, stato: stato)
		return "<b>" + filTeksto.tondi() + "</b>"
	}
}
