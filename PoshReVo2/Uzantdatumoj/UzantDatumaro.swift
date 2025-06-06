import Foundation

import ReVoDatumbazo

struct UzantDatumaro {
	
	var elektitaLingvo: Lingvo
	
	var lingvoj: [Lingvo]
	
	var historio: [Konservitajho]
	
	var konservitaj: [Konservitajho]
	
	var stilo: InterfacStilo
	
	func chuKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
	}
	
	static var komuna: UzantDatumaro {
		UzantDatumoRegilo.komuna.datumaro
	}
	
	// MARK: - Defaultaj valoroj
	
	private static var defaultajLingvoj: [Lingvo] {
		let aparatajLingvoj = NSLocale.preferredLanguages.compactMap { kodo in
			let bazo = kodo.components(separatedBy: "-").first
			return VortaroDatumbazo.komuna.lingvo(kodo: bazo ?? kodo)
		}.filter { lingvo in
			lingvo != Lingvo.esperanto
		}
		
		return [.esperanto] + aparatajLingvoj
	}
	
	private static var defaultaStilo: InterfacStilo = .karamela
	
	static func defaulta() -> UzantDatumaro {
		UzantDatumaro(
			elektitaLingvo: defaultajLingvoj.first!,
			lingvoj: defaultajLingvoj,
			historio: [],
			konservitaj: [],
			stilo: defaultaStilo
		)
	}
}
