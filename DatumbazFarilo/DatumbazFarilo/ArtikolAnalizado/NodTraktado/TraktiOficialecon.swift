extension ArboAnalizilo {
	static func trakti(oficialecon oficialeco: ArtikolNodo, stato: TraktadoStato) -> String {
		return akumuliTekstojn(de: oficialeco, stato: stato)
	}
}
