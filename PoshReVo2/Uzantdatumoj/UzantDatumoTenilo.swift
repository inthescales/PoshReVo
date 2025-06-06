import Foundation

import ReVoDatumbazo

protocol UzantDatumoTenilo {
	func skribi(datumaron: UzantDatumaro)
	
	func legiDatumaron() -> UzantDatumaro?
}

final class UserDefaultsUzantDatumoTenilo: UzantDatumoTenilo {
	private enum DatumoVersio: String {
		case v2_0 = "2.0"
		
		static var lasta: DatumoVersio = .v2_0
	}

	private enum Klavoj {
		static let datumoVersio = "v2_versio"
		static let datumaro = "v2_datumaro"
	}
	
	private var lasta: UzantDatumaro?
	
	init() {}
	
	// MARK: - Skribado kaj Legado
	
	func skribi(datumaron datumaro: UzantDatumaro) {
		let defaults = UserDefaults.standard
		let kodigilo = JSONEncoder()
	
		// Skribi datumoversion
		let datumoj = try? kodigilo.encode(DatumoVersio.lasta.rawValue)
		defaults.set(datumoj, forKey: Klavoj.datumoVersio)
		
		// Skribi datumojn
		if lasta != datumaro {
			let datumoj = try? kodigilo.encode(datumaro)
			defaults.set(datumoj, forKey: Klavoj.datumaro)
		}
		
		defaults.synchronize()
		lasta = datumaro
	}
	
	func legiDatumaron() -> UzantDatumaro? {
		let defaults = UserDefaults.standard
		let malkodigilo = JSONDecoder()
		
		// Legi datumoversion
		var versio: DatumoVersio?
		if let datumoj = defaults.object(forKey: Klavoj.datumoVersio) as? Data,
		   let malkodigita = try? malkodigilo.decode(String.self, from: datumoj) {
			versio = DatumoVersio(rawValue: malkodigita)
		}
		
		guard let versio else {
			return nil
		}
		
		// Legi datumojn laŭ versio
		if let datumoj = defaults.object(forKey: Klavoj.datumaro) as? Data {
			switch versio {
			case .v2_0:
				return malkodiDatumaron_v2_0(datumoj: datumoj, malkodigilo: malkodigilo)
			}
		}
		
		return nil
	}
	
	// MARK: - Legado de individuaj versioj
	private func malkodiDatumaron_v2_0(datumoj: Data, malkodigilo: JSONDecoder) -> UzantDatumaro? {
		try? malkodigilo.decode(UzantDatumaro.self, from: datumoj)
	}
}
