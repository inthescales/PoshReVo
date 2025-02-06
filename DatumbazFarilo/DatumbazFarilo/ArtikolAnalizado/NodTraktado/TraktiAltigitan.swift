extension ArboAnalizilo {
	static func trakti(altigitan altigita: ArtikolNodo, stato: TraktadoStato) -> String {
		let teksto = "<sup>" + traktiFilojn(de: altigita, stato: stato).tondi() + "</sup>"
		return teksto.kunpremi()
	}
}
