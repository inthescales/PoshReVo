import Foundation

import ReVoDatumbazo

extension Avizoj {
	static let elektitaLingvoShanghighis = NSNotification.Name("elektitaLingvoShanghighis")
	static let uzantajLingvojShanghighis = NSNotification.Name("uzantajLingvojShanghighis")
}

final class UzantDatumaro {
	static var komuna: UzantDatumaro = {
		elKonservitajAgordoj()
	}()
	
	var elektitaLingvo: Lingvo
	
	var lingvoj: [Lingvo]
	
	var konservitaj: [Konservitajho]
	
	init(lingvoj: [Lingvo]) {
		self.elektitaLingvo = lingvoj.first!
		self.lingvoj = lingvoj
		self.konservitaj = []
	}
	
	func elektis(lingvon novaLingvo: Lingvo) {
		elektitaLingvo = novaLingvo
		NotificationCenter.default.post(name: Avizoj.elektitaLingvoShanghighis, object: novaLingvo)
	}
	
	func redaktisLingvojn(novaj: [Lingvo]) {
		lingvoj = novaj
		NotificationCenter.default.post(name: Avizoj.uzantajLingvojShanghighis, object: lingvoj)
	}
	
	func konservi(artikolon artikolo: Artikolo) {
		guard !estasKonservita(artikolo: artikolo) else { return }
		
		konservitaj.append(Konservitajho(el: artikolo))
	}
	
	func malkonservi(artikolon artikolo: Artikolo) {
		guard let indekso = konservitaj.firstIndex(
			where: { $0.indekso == artikolo.indekso }
		) else { return }
		
		konservitaj.remove(at: indekso)
	}
	
	func estasKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
	}
	
	static func elKonservitajAgordoj() -> UzantDatumaro {
		return UzantDatumaro(
			lingvoj: [Lingvo.esperanto, Lingvo(kodo: "en", nomo: "angla")]
		)
	}
}
