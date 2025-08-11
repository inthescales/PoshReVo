extension ArboAnalizilo {
	static func trakti(
		rimarkon rimarko: ArtikolNodo,
		numero: Int?,
		sekvasTekston: Bool = true,
		stato: Stato
	) -> String {
		let numeroTeksto = numero.flatMap { " \($0)" } ?? ""
		let titoleto = TekstAtributo.volvi("RIM" + numeroTeksto + ": ", per: .grasa)
		let teksto = titoleto + akumuliTekstojn(de: rimarko, montriFontojn: true, stato: stato).tondi()
		
		// Kutime rimarko aperas sekve de difinan aŭ alian tekston, kaj ni do deziras
		// apartigan '\n' komence. Tamen, en kelkaj kazoj la rimarko ekzistas ekstere
		// derivaĵo aŭ alia subunuo kaj apartenas al la tuta artikolo kaj. Tiukaze, eblas
		// ke neniu teksto antaŭas la rimarkon, kaj '\n' ne estas dezirinda.
		// Vidu 'prem/i', 'modal/o'
		let prefikso = sekvasTekston ? "\n" : ""
		
		return prefikso + TekstAtributo.volvi(teksto.kunpremi().tondi(), per: .rimarko)
	}
}
