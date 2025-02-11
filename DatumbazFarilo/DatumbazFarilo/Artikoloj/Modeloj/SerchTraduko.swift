/// Traduko tiel kiel ĝi aperos en serĉrezultoj.
struct SerchTraduko {
	/// Ĉefa teksto nacilingva (aŭ esperanta), kiu aperos en serĉrezultoj
	let videblaTeksto: String
	
	/// Nomo de esperanta vorto aŭ derivaĵo, se malsamas ol videbla nomo
	let nomo: String
	
	/// Teksto nacilingva kiun serĉanto devas tajpi (eble malsamas ol supraj nomoj)
	let teksto: String
	
	/// Indekzo uzata por ligi al artikolo
	let indekso: String
	
	/// Marko ene de artikolo al kiu apartenas la nacilingva esprimo
	let marko: String
	
	/// Senco al kiu traduko apartenas. Aperas kiel klariga indico apud nomo en serĉrezultoj
	let senco: Int?
}
