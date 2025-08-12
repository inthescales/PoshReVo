import Foundation

import ReVoDatumbazo

/// Protokolo kiu legas kaj skribas uzantdatumoj en nedifinita maniero
protocol UzantDatumoTraktilo {
	func skribi(datumaron: UzantDatumaro)
	
	func legiDatumaron() -> UzantDatumaro?
}

/// Skribas uzantdatumojn al kaj legas ilin el UserDefaults
final class UserDefaultsUzantDatumoTraktilo: UzantDatumoTraktilo {
	/// Nuna kaj estontaj versioj de la datumstrukturo
	/// La numero de datumoversio estas la numero de la apoversio en kiu ĝi unue uziĝis
	private enum DatumoVersio: String {
		case v2_0 = "2.0"
		
		/// La datumoversio kiun uzas la nuna apoversio
		static var lasta: DatumoVersio = .v2_0
	}

	/// Klavos per kiu la datumoj skribiĝos al la disko
	private enum Klavoj {
		/// La versio de la datumaro ĉi tie skribita
		static let datumoVersio = "v2_versio"
		
		/// La datumaro mem
		static let datumaro = "v2_datumaro"
	}
	
	/// La uzantaj datumoj kiel ĝi estis last skribitaj
	private var lasta: UzantDatumaro?
	
	// MARK: - Valorizado?
	
	init() {}
	
	// MARK: - Skribado kaj Legado
	
	/// Skribi la datumaron al la disko
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
	
	/// Legi la datumojn el la disko.
	/// Se la datumaro estas de malnova versio, konverti ĝin en la nuntempan strukturon
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
	
	// TODO: Konstati ĉu eblos legi datumojn se la enhavoj de klaso 'UzantDatumaro' ŝanĝiĝis
	
	/// Malkodi datumojn de versio 2.0
	private func malkodiDatumaron_v2_0(datumoj: Data, malkodigilo: JSONDecoder) -> UzantDatumaro? {
		try? malkodigilo.decode(UzantDatumaro.self, from: datumoj)
	}
}
