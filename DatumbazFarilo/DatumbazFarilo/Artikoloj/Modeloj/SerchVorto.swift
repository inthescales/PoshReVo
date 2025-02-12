/// Esperanta vorto aŭ derivaĵo kiu estos serĉebla
struct SerchVorto: Codable {
	/// Teksto kiun serĉanto devas tajpi, kaj kiu aperos en serĉrezultoj
	let teksto: String
	
	/// Indekzo uzata por ligi al artikolo
	let indekso: String
	
	/// Marko ene de artikolo al kiu apartenas la nacilingva esprimo
	let marko: String
}
