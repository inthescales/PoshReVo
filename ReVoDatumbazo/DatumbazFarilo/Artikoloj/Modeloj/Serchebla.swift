/// Vorto, frazo, aŭ alia termino kiun oni povos serĉi en la aplikaĵo
protocol Serchebla {
	/// Ĉefa teksto kiu montriĝos en serĉrezulo
	var videblaTeksto: String { get }
	
	/// Teksto kiun serĉante devos tajpi
	var serchTeksto: String { get }
	
	/// Subtekso kiu eble aperos flake en rezulto
	var subteksto: String? { get }
	
	/// Indekzo uzata por ligi al artikolo
	var indekso: String { get }
	
	/// Derivaĵa marko ene de artikolo el kiu la esprimo originas
	var derivajhMarko: String? { get }
	
	/// Senco al kiu traduko apartenas. Aperas kiel klariga indico apud nomo en serĉrezultoj
	var senco: Int? { get }
}
