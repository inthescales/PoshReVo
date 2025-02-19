import Foundation

// Vorto, derivaĵo, aŭ frazeo havantan unusaman difinon.
public struct Vorto: Codable {
	/// La vorto, derivaĵo, aŭ frazo mem
    public let titolo: String
	
	/// Difina teksto de la esprimo
    public let teksto: String
	
	/// Identigan marko
    public let marko: String?
	
	/// Oficialeco de la termino. Se estas pluraj variaĵoj, la plej frua oficialeco
    public let ofc: String?
}
