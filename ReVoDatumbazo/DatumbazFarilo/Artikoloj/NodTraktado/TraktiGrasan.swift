extension ArboAnalizilo {
	static func trakti(grasan grasajho: ArtikolNodo, stato: Stato) -> String {
		let filTeksto = akumuliTekstojn(de: grasajho, stato: stato)
		return TekstoAtributo.volvi(tekston: filTeksto.tondi(), per: .grasa)
	}
}
