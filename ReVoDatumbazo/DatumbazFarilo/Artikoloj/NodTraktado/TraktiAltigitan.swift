extension ArboAnalizilo {
	static func trakti(altigitan altigita: ArtikolNodo, stato: Stato) -> String {
		let teksto = TekstAtributo.volvi(
			tekston: akumuliTekstojn(de: altigita, stato: stato).tondi(),
			per: .supera
		)
		return teksto.kunpremi()
	}
}
