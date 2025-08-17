extension ArboAnalizilo {
	static func trakti(trastrekitan: ArtikolNodo, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: trastrekitan, stato: stato)
		return TekstAtributo.volvi(teksto, per: .trastrekita)
	}
}
