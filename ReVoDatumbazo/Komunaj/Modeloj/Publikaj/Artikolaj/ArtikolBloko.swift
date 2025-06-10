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
			return "Teksto:\n\'" + teksto + "\'"
		case .ekzempla(let ekzemploj):
			return "Ekzemploj:\n" + ekzemploj.joined(separator: "\n - ")
		case .traduka(let tradukoj):
			let tekstoj = tradukoj
				.sorted()
				.map { String($0.lingvo.nomo) + ": " + $0.teksto }
			return "Tradukoj:\n" + tekstoj.joined(separator: "\n -")
		}
	}
	
	public func encode(to encoder: any Encoder) throws {
		// Necesas klarigi ke tradukoj estu ordigitaj
		// Alie, ĉi tio estas defaŭlta kodigado
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .subartikolTitola(let teksto):
			var nestedContainer = container.nestedContainer(keyedBy: ArtikolBloko.SubartikolTitolaCodingKeys.self, forKey: .subartikolTitola)
			try nestedContainer.encode(teksto, forKey: ArtikolBloko.SubartikolTitolaCodingKeys.teksto)
		case .derivajhTitola(let teksto, let ofc, let marko):
			var nestedContainer = container.nestedContainer(keyedBy: ArtikolBloko.DerivajhTitolaCodingKeys.self, forKey: .derivajhTitola)
			try nestedContainer.encode(teksto, forKey: ArtikolBloko.DerivajhTitolaCodingKeys.teksto)
			try nestedContainer.encodeIfPresent(ofc, forKey: ArtikolBloko.DerivajhTitolaCodingKeys.ofc)
			try nestedContainer.encodeIfPresent(marko, forKey: ArtikolBloko.DerivajhTitolaCodingKeys.marko)
		case .teksta(let teksto):
			var nestedContainer = container.nestedContainer(keyedBy: ArtikolBloko.TekstaCodingKeys.self, forKey: .teksta)
			try nestedContainer.encode(teksto, forKey: ArtikolBloko.TekstaCodingKeys.teksto)
		case .ekzempla(let ekzemploj):
			var nestedContainer = container.nestedContainer(keyedBy: ArtikolBloko.EkzemplaCodingKeys.self, forKey: .ekzempla)
			try nestedContainer.encode(ekzemploj, forKey: ArtikolBloko.EkzemplaCodingKeys.ekzemploj)
		case .traduka(let tradukoj):
			var nestedContainer = container.nestedContainer(keyedBy: ArtikolBloko.TradukaCodingKeys.self, forKey: .traduka)
			try nestedContainer.encode(tradukoj.sorted(), forKey: ArtikolBloko.TradukaCodingKeys.tradukoj)
		}
	}
}
