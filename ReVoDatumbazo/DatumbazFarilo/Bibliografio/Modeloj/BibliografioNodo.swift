/// Arbonodo en la bibliografia strukturo
/// Spegulas la artikolan klason 'ArtikolNodo'
class BibliografioNodo {
	let tipo: BibliografioNodTipo
	var filoj: [BibliografioNodo]
	
	init?(nomo: String, ecoj: [String: String] = [:]) {
		guard let tipo = BibliografioNodTipo.el(nomo: nomo, ecoj: ecoj) else {
			return nil
		}
		
		self.tipo = tipo
		self.filoj = []
	}
	
	init(tipo: BibliografioNodTipo) {
		self.tipo = tipo
		self.filoj = []
	}
}
