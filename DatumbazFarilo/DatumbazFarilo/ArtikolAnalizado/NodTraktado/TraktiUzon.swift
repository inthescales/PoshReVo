extension ArboAnalizilo {
	static func trakti(uzon uzo: ArtikolNodo, tipo: String?, stato: TraktadoStato) -> String {
		let teksto = traktiFilojn(de: uzo, stato: stato)
		
		switch tipo {
		case "fak":
			return "[\(teksto)] "
		case "klr", "stl":
			let stilTeksto = stato.stiloj[teksto] ?? teksto
			return "(\(stilTeksto)) "
		case nil:
			return teksto
		default:
			assert(false, "Neatendita stilo")
			return ""
		}
	}
}
