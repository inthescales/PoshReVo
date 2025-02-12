extension ArboAnalizilo {
	static func trakti(altigitan altigita: ArtikolNodo, stato: Stato) -> String {
		let teksto = "<sup>" + akumuliTekstojn(de: altigita, stato: stato).tondi() + "</sup>"
		return teksto.kunpremi()
	}
}
