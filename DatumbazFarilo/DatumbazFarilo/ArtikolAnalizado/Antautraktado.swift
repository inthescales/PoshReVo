enum Antautraktado {
	/// Kodoj kiuj uziĝas en artikoloj, tamen mi ne scias kie ĝi difiniĝas
	static let specialaj = [
		"Z": "Zamenhof"
	]
	
	/// Efikas ŝanĝojn en la XML-an tekston antaŭ ke ĝi estos analizita.
	/// Aŭ la Swift-a `XMLParserDelegate` ne bone traktas liter-kodojn, aŭ mi ne komprenas kiel ĝi funkcias.
	/// Iukaze, ĉi tie ni anstataŭas la literkodojn per siaj literoj
	static func antautrakti(tekston teksto: String, literoj: [String: String]) -> String {
		let regex = try! Regex("&(.*?);")
		return teksto.replacing(regex) { (match: Regex.Match) in
			let kodo = String(match.output[1].substring!)
			if let litero = literoj[kodo] {
				return litero
			} else if let teksto = specialaj[kodo] {
				return teksto
			} else {
				return ""
			}
		}
	}
}
