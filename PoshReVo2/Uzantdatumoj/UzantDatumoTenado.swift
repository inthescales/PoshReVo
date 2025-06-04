import Foundation

import ReVoDatumbazo

protocol UzantDatumoTenado {
	static func skribi(datumaron: UzantDatumaro)
	
	static func legiDatumaron() -> UzantDatumaro
}

final class UserDefaultsUzantDatumoTenado: UzantDatumoTenado {
	private enum Klavoj {
		static let lingvoj = "lingvoj"
		static let historio = "historio"
		static let konservitaj = "konservitaj"
	}
	
	private static var lasta: UzantDatumaro?
	
	init() {}
	
	// MARK: - Defaultaj valoroj
	
	static var defaultajLingvoj: [Lingvo] {
		let aparatajLingvoj = NSLocale.preferredLanguages.compactMap { kodo in
			let bazo = kodo.components(separatedBy: "-").first
			return VortaroDatumbazo.komuna.lingvo(kodo: bazo ?? kodo)
		}.filter { lingvo in
			lingvo != Lingvo.esperanto
		}
		
		return [.esperanto] + aparatajLingvoj
	}
	
	// MARK: - Skribado kaj Legado
	
	static func skribi(datumaron datumaro: UzantDatumaro) {
		let defaults = UserDefaults.standard
		let kodigilo = JSONEncoder()
	
		// Skribi lingvojn
		if lasta?.lingvoj != datumaro.lingvoj {
			let datumoj = try? kodigilo.encode(datumaro.lingvoj)
			defaults.set(datumoj, forKey: Klavoj.lingvoj)
		}

		// Skribi historion
		if lasta?.historio != datumaro.historio {
			let datumoj = try? kodigilo.encode(datumaro.historio)
			defaults.set(datumoj, forKey: Klavoj.historio)
		}

		// Skribi konservitajn artikolojn
		if lasta?.konservitaj != datumaro.konservitaj {
			let datumoj = try? kodigilo.encode(datumaro.konservitaj)
			defaults.set(datumoj, forKey: Klavoj.konservitaj)
		}

		// TODO: Konservi stilon

		defaults.synchronize()
		lasta = datumaro
	}
	
	static func legiDatumaron() -> UzantDatumaro {
		let defaults = UserDefaults.standard
		let malkodigilo = JSONDecoder()
		
		let lingvoj: [Lingvo]
		if let datumoj = defaults.object(forKey: Klavoj.lingvoj) as? Data,
		   let malkodigita = try? malkodigilo.decode([Lingvo].self, from: datumoj) {
			lingvoj = malkodigita
		} else {
			lingvoj = defaultajLingvoj
		}

		let historio: [Konservitajho]
		if let datumoj = defaults.object(forKey: Klavoj.historio) as? Data,
		   let malkodigita = try? malkodigilo.decode([Konservitajho].self, from: datumoj) {
			historio = malkodigita
		} else {
			historio = []
		}

		let konservitaj: [Konservitajho]
		if let datumoj = defaults.object(forKey: Klavoj.konservitaj) as? Data,
		   let malkodigita = try? malkodigilo.decode([Konservitajho].self, from: datumoj) {
			konservitaj = malkodigita
		} else {
			konservitaj = []
		}
		
		return UzantDatumaro(
			elektitaLingvo: lingvoj.first!,
			lingvoj: lingvoj,
			historio: historio,
			konservitaj: konservitaj
		)
	}
}
