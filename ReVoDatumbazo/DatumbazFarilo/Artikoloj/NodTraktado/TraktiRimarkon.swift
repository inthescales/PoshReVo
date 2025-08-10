extension ArboAnalizilo {
	static func trakti(
		rimarkon rimarko: ArtikolNodo,
		numero: Int?,
		sekvasTekston: Bool = true,
		stato: Stato
	) -> String {
		let numeroTeksto = numero.flatMap { " \($0)" } ?? ""
		let antauteksto = TekstAtributo.volvi("RIM" + numeroTeksto, per: .grasa)
		let teksto = antauteksto + ": " + akumuliTekstojn(de: rimarko, stato: stato).tondi()
		
		// Kutime ni deziras komencan '\n', ĉar rimarko rekte sekvas difinon aŭ similan tekston.
		// Tamen, en kelkaj kazoj la rimarko ekzistas ekstere de iu ajn derivaĵo, senco, ks.,
		// kaj apartenas al la tuta artikolo. Tiukaze '\n' ne necesas.
		// Vidu 'premi'
		let prefikso = sekvasTekston ? "\n" : ""
		
		return prefikso + TekstAtributo.volvi(teksto.kunpremi().tondi(), per: .rimarko)
	}
}
