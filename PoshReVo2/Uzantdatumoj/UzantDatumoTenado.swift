import Foundation

import ReVoDatumbazo

protocol UzantDatumoTenilo {
	func skribi(datumaron: UzantDatumaro)
	
	func legiDatumaron() -> UzantDatumaro
}

final class UserDefaultsUzantDatumoTenilo: UzantDatumoTenilo {
	private enum Klavoj {
		static let lingvoj = "lingvoj"
		static let historio = "historio"
		static let konservitaj = "konservitaj"
		static let stilo = "stilo"
	}
	
	private var lasta: UzantDatumaro?
	
	init() {}
	
	// MARK: - Defaultaj valoroj
	
	private var defaultajLingvoj: [Lingvo] {
		let aparatajLingvoj = NSLocale.preferredLanguages.compactMap { kodo in
			let bazo = kodo.components(separatedBy: "-").first
			return VortaroDatumbazo.komuna.lingvo(kodo: bazo ?? kodo)
		}.filter { lingvo in
			lingvo != Lingvo.esperanto
		}
		
		return [.esperanto] + aparatajLingvoj
	}
	
	private var defaultaStilo: InterfacStilo = .karamela
	
	// MARK: - Skribado kaj Legado
	
	func skribi(datumaron datumaro: UzantDatumaro) {
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

		// Skribi stilon
		if lasta?.stilo.identigilo != datumaro.stilo.identigilo {
			let datumoj = try? kodigilo.encode(datumaro.stilo.identigilo)
			defaults.set(datumoj, forKey: Klavoj.stilo)
		}

		defaults.synchronize()
		lasta = datumaro
	}
	
	func legiDatumaron() -> UzantDatumaro {
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
		
		let stilo: InterfacStilo
		if let datumoj = defaults.object(forKey: Klavoj.stilo) as? Data,
		   let malkodigitaNomo = try? malkodigilo.decode(String.self, from: datumoj),
		   let stiloElIdentigilo = InterfacStilo.kun(nomo: malkodigitaNomo) {
			stilo = stiloElIdentigilo
		} else {
			stilo = defaultaStilo
		}
		
		return UzantDatumaro(
			elektitaLingvo: lingvoj.first!,
			lingvoj: lingvoj,
			historio: historio,
			konservitaj: konservitaj,
			stilo: stilo
		)
	}
}
