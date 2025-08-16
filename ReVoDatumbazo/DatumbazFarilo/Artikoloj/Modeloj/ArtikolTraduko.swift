/// Traduko tiel kiel ĝi aperos en artikolo.
/// Ne ĉiam egalas al tiuj kiuj aperas en serĉrezultoj.
struct ArtikolTraduko {
	/// La esperanta termino tradukata, se ĝi malsamas ol la derivaĵtermino
	let apartaNomo: String?
	
	/// La nacilingva teksto de la traduko.
	let teksto: String
	
	/// La plej proksima marko super ĉi-traduko (ekz. en senco, derivaĵo, ks.).
	let marko: String
	
	/// Senco al kiu la traduko apartenas, se estas.
	let senco: Int?
	
	/// Subsenco al kiu la traduko apartenas, se estas.
	let subsenco: Int?
	
	// MARK: - Helpiloj
	
	/// Ĉu la traduko havas prezentotan nomon alian ol tiu de ĝia derivaĵo
	var chuHavasApartanNomon: Bool {
		apartaNomo != nil
	}
}
