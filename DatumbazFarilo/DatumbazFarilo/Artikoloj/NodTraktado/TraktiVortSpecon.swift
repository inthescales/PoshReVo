extension ArboAnalizilo {
	static func trakti(vortSpecon vortSpeco: ArtikolNodo, stato: TraktadoStato) -> String {
		return akumuliTekstojn(de: vortSpeco, stato: stato)
	}
}
