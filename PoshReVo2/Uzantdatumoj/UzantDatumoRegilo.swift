import Foundation

import ReVoDatumbazo

extension Avizoj {
	static let elektitaLingvoShanghighis = NSNotification.Name("elektitaLingvoShanghighis")
	static let uzantajLingvojShanghighis = NSNotification.Name("uzantajLingvojShanghighis")
	static let konservitajShanghighis = NSNotification.Name("konservitajShanghighis")
	static let historioShanghighis = NSNotification.Name("historioShanghighis")
}

final class UzantDatumoRegilo {
	private enum Konstantoj {
		static let historioLimo = 100
	}
	
	static var komuna = UzantDatumoRegilo()
	
	private(set) var datumaro: UzantDatumaro
	
	init() {
		datumaro = UserDefaultsUzantDatumoTenado.legiDatumaron()
	}
	
	// MARK: - Lingvoj
	
	func elektis(lingvon novaLingvo: Lingvo) {
		datumaro.elektitaLingvo = novaLingvo
		NotificationCenter.default.post(
			name: Avizoj.elektitaLingvoShanghighis,
			object: novaLingvo
		)
	}
	
	func redaktisLingvojn(novaj: [Lingvo]) {
		datumaro.lingvoj = novaj
		NotificationCenter.default.post(
			name: Avizoj.uzantajLingvojShanghighis,
			object: novaj
		)
	}
	
	// MARK: - Historio
	
	func markiVizititan(artikolon artikolo: Artikolo) {
		let vizitito = Konservitajho(el: artikolo)
		guard !datumaro.historio.contains(vizitito) else {
			return
		}
		
		datumaro.historio.append(vizitito)
		while datumaro.historio.count > Konstantoj.historioLimo {
			datumaro.historio.remove(at: 0)
		}
		
		NotificationCenter.default.post(
			name: Avizoj.historioShanghighis,
			object: datumaro.historio
		)
	}
	
	func forigiHistorion() {
		datumaro.historio = []
	}
	
	// MARK: - Konservado
	
	func konservi(artikolon artikolo: Artikolo) {
		guard !datumaro.chuKonservita(artikolo: artikolo) else { return }
		
		datumaro.konservitaj.append(Konservitajho(el: artikolo))
		NotificationCenter.default.post(
			name: Avizoj.konservitajShanghighis,
			object: datumaro.konservitaj
		)
	}
	
	func malkonservi(artikolon artikolo: Artikolo) {
		guard let indekso = datumaro.konservitaj.firstIndex(
			where: { $0.indekso == artikolo.indekso }
		) else { return }
		
		datumaro.konservitaj.remove(at: indekso)
		NotificationCenter.default.post(
			name: Avizoj.konservitajShanghighis,
			object: datumaro.konservitaj
		)
	}
	
	func forigiKonservitajn() {
		datumaro.konservitaj = []
	}
}
