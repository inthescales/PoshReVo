/// Esperanta vorto aŭ derivaĵo kiu apartenas al fako
struct FakVorto: Codable {
	/// Teksto kiu vidiĝu en listo da fakvortoj
	let teksto: String
	
	/// Indekso kiu ligas al artikolo
	let indekso: String
	
	/// Marko ene de artikolo
	let marko: String
	
	/// Senco ene de derivaĵo
	let senco: Int?
}
