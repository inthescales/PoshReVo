final class BlokAkumulilo {
	private var teksto = ""
	private var blokoj: [ArtikolBloko] = []
		
	// MARK: - Demandado
	
	func tenasTekston() -> Bool {
		return !teksto.isEmpty
	}
	
	// MARK: - Akumulado
	
	func aldoni(tekston teksto: String) {
		self.teksto += teksto
	}
	
	func aldoni(blokojn blokoj: [ArtikolBloko]) {
		malbufrigi()
		self.blokoj += blokoj
	}
	
	// MARK: - Tekstpurigiloj
	
	func kunpremiTekston() {
		teksto = teksto.kunpremi()
	}
	
	func tondiTekston() {
		teksto = teksto.tondi()
	}
	
	// MARK: - Blokfarado
	
	func fariBlokojn() -> [ArtikolBloko] {
		malbufrigi()
		return blokoj
	}
	
	// MARK: - Malbufrigado
	
	private func malbufrigi() {
		if !teksto.isEmpty {
			blokoj.append(.teksta(teksto: teksto))
			teksto = ""
		}
	}
}
