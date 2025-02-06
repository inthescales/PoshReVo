extension ArboAnalizilo {
	static func trakti(nomon nomo: ArtikolNodo, stato: TraktadoStato) -> String {
		return traktiFilojn(de: nomo, stato: stato).tondi()
	}
}
