import ReVoDatumbazo

/// Reprezentas ligon al konservita artikolo
final class Konservitajho: Codable {
	let nomo: String
	let indekso: String
	
	init(el artikolo: Artikolo) {
		nomo = artikolo.titolo
		indekso = artikolo.indekso
	}
}
