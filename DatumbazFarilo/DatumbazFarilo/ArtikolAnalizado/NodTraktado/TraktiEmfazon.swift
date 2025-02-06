extension ArboAnalizilo {
	static func trakti(emfazon emfazo: ArtikolNodo, stato: TraktadoStato) -> String {
		let teksto = "<b>" + traktiFilojn(de: emfazo, stato: stato).tondi() + "</b>"
		return teksto.kunpremi().tondi()
	}
}
