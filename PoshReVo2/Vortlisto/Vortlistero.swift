import ReVoDatumbazo

protocol Vortlistero {
	var teksto: String { get }
	var subteksto: String? { get }
}

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

final class Esplorlistero: Vortlistero {
	let teksto: String
	let subteksto: String? = nil
	let destino: Destino
	
	init(teksto: String, destino: Destino) {
		self.teksto = teksto
		self.destino = destino
	}
}

final class Uzantlistero: Vortlistero {
	let teksto: String
	let subteksto: String? = nil
	let indekso: String
	
	init(teksto: String, indekso: String) {
		self.teksto = teksto
		self.indekso = indekso
	}
}
