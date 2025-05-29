import Foundation

import ReVoDatumbazo

extension Avizoj {
	static let elektitaLingvoShanghighis = NSNotification.Name("elektitaLingvoShanghighis")
	static let uzantajLingvojShanghighis = NSNotification.Name("uzantajLingvojShanghighis")
	static let konservitajShanghighis = NSNotification.Name("konservitajShanghighis")
	static let historioShanghighis = NSNotification.Name("historioShanghighis")
}

final class UzantDatumaro {
	private enum Konstantoj {
		static let historioLimo = 100
	}
	static var komuna: UzantDatumaro = {
		elKonservitajAgordoj()
	}()
	
	private(set) var elektitaLingvo: Lingvo
	
	private(set) var lingvoj: [Lingvo]
	
	private(set) var historio: [Konservitajho]
	
	private(set) var konservitaj: [Konservitajho]
	
	init(lingvoj: [Lingvo]) {
		self.elektitaLingvo = lingvoj.first!
		self.lingvoj = lingvoj
		self.historio = []
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
	
	// MARK: - Historio
	
	func vizitis(artikolon artikolo: Artikolo) {
		let vizitito = Konservitajho(el: artikolo)
		guard !historio.contains(vizitito) else {
			return
		}
		
		historio.append(vizitito)
		while historio.count > Konstantoj.historioLimo {
			historio.remove(at: 0)
		}
		
		NotificationCenter.default.post(name: Avizoj.historioShanghighis, object: historio)
	}
	
	func forigiHistorion() {
		historio = []
	}
	
	// MARK: - Konservadon
	
	func konservi(artikolon artikolo: Artikolo) {
		guard !estasKonservita(artikolo: artikolo) else { return }
		
		konservitaj.append(Konservitajho(el: artikolo))
		NotificationCenter.default.post(name: Avizoj.konservitajShanghighis, object: konservitaj)
	}
	
	func malkonservi(artikolon artikolo: Artikolo) {
		guard let indekso = konservitaj.firstIndex(
			where: { $0.indekso == artikolo.indekso }
		) else { return }
		
		konservitaj.remove(at: indekso)
		NotificationCenter.default.post(name: Avizoj.konservitajShanghighis, object: konservitaj)
	}
	
	func estasKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
	}
	
	func forigiKonservitajn() {
		konservitaj = []
	}
	
	// MARK: - Starigado
	
	static func elKonservitajAgordoj() -> UzantDatumaro {
		return UzantDatumaro(
			lingvoj: [Lingvo.esperanto, Lingvo(kodo: "en", nomo: "angla")]
		)
	}
}
