extension ArboAnalizilo {
	static func trakti(indicon indico: ArtikolNodo, stato: Stato) -> String {
		let teksto = TekstoAtributo.volvi(
			tekston: akumuliTekstojn(de: indico, stato: stato).tondi(),
			per: .suba
		)
		return teksto.kunpremi()
	}
}
