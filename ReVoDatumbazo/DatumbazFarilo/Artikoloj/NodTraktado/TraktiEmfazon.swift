extension ArboAnalizilo {
	static func trakti(emfazon emfazo: ArtikolNodo, stato: Stato) -> String {
		let teksto = TekstAtributo.volvi(
			tekston: akumuliTekstojn(de: emfazo, stato: stato).tondi(),
			per: .grasa
		)
		return teksto.kunpremi().tondi()
	}
}
