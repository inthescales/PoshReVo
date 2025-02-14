/// Traduko tiel kiel ĝi aperos en serĉrezultoj.
struct SerchTraduko: Codable {
	/// Teksto nacilingva kiun serĉanto devas tajpi
	let serchTeksto: String
	
	/// Ĉefa teksto nacilingva, kiu aperos en serĉrezultoj
	let videblaTeksto: String
	
	/// Nomo de esperanta vorto, derivaĵo, aŭ termino
	let esperantaNomo: String
	
	/// Indekzo uzata por ligi al artikolo
	let indekso: String
	
	/// Marko ene de artikolo al kiu apartenas la nacilingva esprimo
	let marko: String
	
	/// Senco al kiu traduko apartenas. Aperas kiel klariga indico apud nomo en serĉrezultoj
	let senco: Int?
}

extension SerchTraduko: Serchebla {
	var subteksto: String? {
		esperantaNomo
	}
	
	var derivajhMarko: String? {
		marko
	}

	var klavoj: [String] {
		(serchTeksto == videblaTeksto)
			? [serchTeksto]
			: [serchTeksto, videblaTeksto]
	}
}
