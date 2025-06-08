public enum ArtikolBloko: Codable {
	case subartikolTitola(teksto: String)
	case derivajhTitola(teksto: String, ofc: String?, marko: String?)
	case teksta(teksto: String)
	case ekzempla(ekzemploj: [String])
	case traduka(tradukoj: [Traduko])
	
	var description: String {
		switch self {
		case .subartikolTitola(let teksto):
			return "Subartikolo: \'" + teksto + "\'"
		case .derivajhTitola(let teksto, let ofc, let marko):
			let ofcTeksto: String = ofc.flatMap { " (\($0))" } ?? ""
			let markTeksto: String = marko.flatMap { " - " + $0 } ?? ""
			return "Derivaĵo: \'" + teksto + "\'" + ofcTeksto + markTeksto
		case .teksta(let teksto):
			return "Teksto: \'" + teksto + "\'"
		case .ekzempla(let ekzemploj):
			return "Ekzemploj:" + ekzemploj.joined(separator: "\n - ")
		case .traduka(let tradukoj):
			let tekstoj = tradukoj
				.sorted()
				.map { String($0.lingvo.nomo) + ": " + $0.teksto }
			return "Tradukoj:" + tekstoj.joined(separator: "\n -")
		}
	}
}
