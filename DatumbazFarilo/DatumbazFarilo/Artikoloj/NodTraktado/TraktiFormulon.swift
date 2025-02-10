extension ArboAnalizilo {
	static func trakti(formulon formulo: ArtikolNodo, stato: TraktadoStato) -> String {
		// Formulo ŝajne uzas apartan tiparon (MJXc-TeX-main-*) en la retejo. Esploro indas.
		// vd. ekz. artikolon 'logaritm/o'
		let teksto = akumuliTekstojn(de: formulo, stato: stato).tondi()
		return teksto.kunpremi().tondi()
	}
}
