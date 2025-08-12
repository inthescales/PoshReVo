import ReVoDatumbazo

/// Ero montrebla de vortolisto
protocol Vortlistero {
	var teksto: String { get }
	var subteksto: String? { get }
}

/// Ero montrata en rezultoj de vortserĉo.
/// Povas havi subtekston, kaj povas havi plurajn destinojn
final class Serchlistero: Vortlistero {
	let teksto: String
	let subteksto: String?
	let destinoj: [Destino]
	
	init(teksto: String, subteksto: String?, destinoj: [Destino]) {
		self.teksto = teksto
		self.subteksto = subteksto
		self.destinoj = destinoj
	}
}

/// Ero montrata en esploraj vortlistoj.
/// Neniam havas subtekston, kaj havas nur unu destinon
final class Esplorlistero: Vortlistero {
	let teksto: String
	let subteksto: String? = nil
	let destino: Destino
	
	init(teksto: String, destino: Destino) {
		self.teksto = teksto
		self.destino = destino
	}
}

/// Ero montrata en uzantaj vortlistoj (historio kaj konservitaj).
/// Neniam havas subtekston, kaj kondukas al artikolo per indekso-ĉeno, ne Destino
final class Uzantlistero: Vortlistero {
	let teksto: String
	let subteksto: String? = nil
	let indekso: String
	
	init(teksto: String, indekso: String) {
		self.teksto = teksto
		self.indekso = indekso
	}
	
	convenience init(el konservita: Konservitajho) {
		self.init(teksto: konservita.nomo, indekso: konservita.indekso)
	}
}
