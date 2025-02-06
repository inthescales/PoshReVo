extension ArboAnalizilo {
	static func trakti(oficialecon oficialeco: ArtikolNodo, stato: TraktadoStato) -> String {
		return traktiFilojn(de: oficialeco, stato: stato).tondi()
	}
}
