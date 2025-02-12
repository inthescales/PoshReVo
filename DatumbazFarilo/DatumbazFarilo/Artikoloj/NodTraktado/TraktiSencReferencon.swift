extension ArboAnalizilo {
	static func trakti(
		sencReferencon sencReferenco: ArtikolNodo,
		marko: String,
		stato: Stato
	) -> String {
		// Pro tio ke ne eblas antaŭscii la ordon laŭ kiu la artikoloj legiĝos,
		// kaj tio ke (mi supozas) eblas ke estos cirklaj senc-referencoj, ĉi tie
		// nur eblas marki la lokojn en kiu superskriptoj devos aperi. En posta
		// fazo, ni anstataŭos ilin per la finaj tekstoj
		return "<sncref mrk=\"\(marko)\"/>"
	}
}
