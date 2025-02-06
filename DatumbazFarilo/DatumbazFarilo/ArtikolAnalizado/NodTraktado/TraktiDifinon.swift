extension ArboAnalizilo {
	static func trakti(difinon difino: ArtikolNodo, stato: TraktadoStato) -> String {
		return traktiFilojn(de: difino, stato: stato).kunpremi().tondi()
	}
}
