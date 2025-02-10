extension ArboAnalizilo {
	static func trakti(rimarkon rimarko: ArtikolNodo, stato: TraktadoStato) -> String {
		let teksto = "<b>Rim</b>: " + akumuliTekstojn(de: rimarko, stato: stato).tondi()
		return "\n" + teksto.kunpremi().tondi()
	}
}
