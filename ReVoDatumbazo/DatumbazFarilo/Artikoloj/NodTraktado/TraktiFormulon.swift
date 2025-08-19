extension ArboAnalizilo {
	static func trakti(formulon formulo: ArtikolNodo, stato: Stato) -> String {
		// TODO: Formulo ŝajne uzas apartan tiparon (MJXc-TeX-main-*) en la retejo. Esploro indas.
		// vd. ekz. artikolon 'logaritm/o'
		
		// TODO: Formulo en ekzemple estu nekursiva.
		// vd. -iliard
		
		let teksto = akumuliTekstojn(de: formulo, stato: stato).tondi()
		return teksto.kunpremi().tondi()
	}
}
