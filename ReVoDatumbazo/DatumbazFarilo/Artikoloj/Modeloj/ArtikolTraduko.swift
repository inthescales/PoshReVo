/// Traduko tiel kiel ĝi aperos en artikolo.
/// Ne ĉiam egalas al tiuj kiuj aperas en serĉrezultoj.
struct ArtikolTraduko {
	// Ĉi tiu variablo estas postrestaĵo de V1a maniero de prezenti tradukojn.
	// Nuntempe, tiuj nomoj nur vidiĝos se 'transpasNomo' estas 'true'. Do,
	// mi proponas ke oni forigu 'transpasNomo' kaj fari 'nomo' nedeviga.
	// TODO: Efektivigi ĉi tiun ideon
	/// La esperanta termino tradukata. Uzas ~ojn en loko de kapvorto.
	let nomo: String
	
	/// La nacilingva teksto de la traduko.
	let teksto: String
	
	/// La plej proksima marko super ĉi-traduko (ekz. en senco, derivaĵo, ks.).
	let marko: String
	
	/// Senco al kiu la traduko apartenas, se estas.
	let senco: Int?
	
	/// Subsenco al kiu la traduko apartenas, se estas.
	let subsenco: Int?
	
	/// Ĉu transpasa nomo uziĝas (ekz. je tradukoj ene de ekzemploj).
	let transpasNomo: Bool
}
