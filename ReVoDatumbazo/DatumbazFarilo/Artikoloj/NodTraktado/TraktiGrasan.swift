extension ArboAnalizilo {
	static func trakti(grasan grasajho: ArtikolNodo, stato: Stato) -> String {
		let filTeksto = akumuliTekstojn(de: grasajho, stato: stato)
		return TekstAtributo.volvi(filTeksto.tondi(), per: .grasa)
	}
}
