extension ArboAnalizilo {
	static func trakti(
		rimarkon rimarko: ArtikolNodo,
		sekvasTekston: Bool = true,
		stato: Stato
	) -> String {
		let antauteksto = TekstAtributo.volvi("RIM", per: .grasa)
		let teksto = antauteksto + ": " + akumuliTekstojn(de: rimarko, stato: stato).tondi()
		
		// Kutime ni deziras komencan '\n', ĉar rimarko rekte sekvas difinon aŭ similan tekston.
		// Tamen, en kelkaj kazoj la rimarko ekzistas ekstere de iu ajn derivaĵo, senco, ks.,
		// kaj apartenas al la tuta artikolo. Tiukaze '\n' ne necesas.
		// Vidu 'premi'
		let prefikso = sekvasTekston ? "\n" : ""
		
		return prefikso + TekstAtributo.volvi(teksto.kunpremi().tondi(), per: .rimarko)
	}
}
