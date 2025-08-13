import ReVoDatumbazo

/// Reprezentas ligon al konservita artikolo
struct Konservitajho: Equatable, Codable {
	/// Nomo montrota en, ekz., listoj
	let nomo: String
	
	/// Indekso de la artikolo
	let indekso: String
	
	/// Marko ene de artikolo. Ne uzata nuntempe, sed efektivas nun por ke nuntempaj datumoj estu kongruaj kun estontaj versioj
	let marko: String?
	
	init(el artikolo: Artikolo) {
		nomo = artikolo.titolo
		indekso = artikolo.indekso
		marko = nil
	}
}
