// Nodo en artikola arbo-strukturo.
// Spegulas elementon en XML-dosiero.
class ArtikolNodo {
	let tipo: NodTipo
	var filoj: [ArtikolNodo]
	
	init?(nomo: String, ecoj: [String: String] = [:]) {
		guard let tipo = NodTipo.el(nomo: nomo, ecoj: ecoj) else {
			return nil
		}
		
		self.tipo = tipo
		self.filoj = []
	}
	
	init(tipo: NodTipo) {
		self.tipo = tipo
		self.filoj = []
	}
}
