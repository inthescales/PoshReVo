extension ArboAnalizilo {
	static func trakti(rimarkon rimarko: ArtikolNodo, stato: Stato) -> String {
		let antauteksto = TekstoAtributo.volvi(tekston: "RIM", per: .grasa)
		let teksto = antauteksto + ": " + akumuliTekstojn(de: rimarko, stato: stato).tondi()
		return "\n" + teksto.kunpremi().tondi()
	}
}
