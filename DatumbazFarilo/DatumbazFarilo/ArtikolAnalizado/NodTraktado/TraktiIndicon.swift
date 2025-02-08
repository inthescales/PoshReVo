extension ArboAnalizilo {
	static func trakti(indicon indico: ArtikolNodo, stato: TraktadoStato) -> String {
		let teksto = "<sub>" + akumuliTekstojn(de: indico, stato: stato).tondi() + "</sub>"
		return teksto.kunpremi()
	}
}
