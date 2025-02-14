protocol Serchebla {
	var videblaTeksto: String { get }
	
	/// Nomo de esperanta vorto, derivaĵo, aŭ termino
	var subteksto: String? { get }
	
	var klavoj: [String] { get }
	
	/// Indekzo uzata por ligi al artikolo
	var indekso: String { get }
	
	/// Marko ene de artikolo al kiu apartenas la nacilingva esprimo
	var derivajhMarko: String? { get }
	
	/// Senco al kiu traduko apartenas. Aperas kiel klariga indico apud nomo en serĉrezultoj
	var senco: Int? { get }
}
