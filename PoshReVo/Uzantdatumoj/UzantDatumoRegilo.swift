import Foundation

import ReVoDatumbazo

extension Avizoj {
	/// Sendata kiam uzanto elektas serĉlingvo
	static let elektitaLingvoShanghighis = NSNotification.Name("elektitaLingvoShanghighis")
	
	/// Sendata kiam uzanto ŝanĝas siajn lingvojn
	static let uzantajLingvojShanghighis = NSNotification.Name("uzantajLingvojShanghighis")
	
	/// Sendata kiam uzanto konservas aŭ malkonservas artikolon
	static let konservitajShanghighis = NSNotification.Name("konservitajShanghighis")
	
	/// Sendata kiam uzanto ekvidas artikolekranon
	static let historioShanghighis = NSNotification.Name("historioShanghighis")
	
	/// Sendata kiam uzanto elektas stilon
	static let stiloShanghighis = NSNotification.Name("stiloShanghighis")
}

/// Klaso kiu regas uzantajn datumojn. Disponigas la nuna datumostato, kaj
/// havas metodojn por ŝanĝi ĉiujn datumerojn.
final class UzantDatumoRegilo {
	private enum Konstantoj {
		/// Maksimuma kvanto da artikoloj kiuj estos retenataj en la historio
		static let historioLimo = 100
	}
	
	/// Komuna datumoregilo
	static var komuna = UzantDatumoRegilo(traktilo: UserDefaultsUzantDatumoTraktilo())
	
	// MARK: - Agordoj
	
	/// La nuna stato de la uzantaj datumoj
	private(set) var datumaro: UzantDatumaro
	
	/// Traktilo por legado kaj skribado de uzantaj datumoj al/el la aparatmemoro
	private let traktilo: UzantDatumoTraktilo
	
	// MARK: - Valorizado
	
	init(traktilo: UzantDatumoTraktilo) {
		self.traktilo = traktilo
		
		// Unue, provu legi aktualan datumaron.
		// Se mankas tio, provu legi V1an datumojn.
		// Se mankas tio ankaŭ, uzu defaŭltan
		// TODO: Ŝanĝu kiam ni ne plu subtenas V1ajn datumojn
		datumaro = traktilo.legiDatumaron()
			?? V1UzantDatumoTenilo.legiV1Datumaron()
			?? UzantDatumaro.defaulta()
	}
	
	// MARK: - Lingvoj
	
	/// Ŝanĝas la nune-elektita lingvo
	func elektis(lingvon novaLingvo: Lingvo) {
		datumaro.elektitaLingvo = novaLingvo
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.elektitaLingvoShanghighis,
			object: novaLingvo
		)
	}
	
	/// Ŝanĝas la uzantaj lingvoj
	func redaktisLingvojn(novaj: [Lingvo]) {
		datumaro.lingvoj = novaj
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.uzantajLingvojShanghighis,
			object: novaj
		)
	}
	
	// MARK: - Historio
	
	/// Registri artikolon en la historio, kaj aliaj respondoj al artikollegado
	func markiVizititan(artikolon artikolo: Artikolo) {
		let vizitito = Konservitajho(el: artikolo)
		guard !datumaro.historio.contains(vizitito) else {
			return
		}
		
		datumaro.historio.append(vizitito)
		while datumaro.historio.count > Konstantoj.historioLimo {
			datumaro.historio.remove(at: 0)
		}
		
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.historioShanghighis,
			object: datumaro.historio
		)
	}
	
	/// Forigas la artikol-historion
	func nuligiHistorion() {
		datumaro.historio = []
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.historioShanghighis,
			object: datumaro.historio
		)
	}
	
	// MARK: - Konservado
	
	/// Konservas artikolon
	func konservi(artikolon artikolo: Artikolo) {
		guard !datumaro.chuKonservita(artikolo: artikolo) else { return }
		
		datumaro.konservitaj.append(Konservitajho(el: artikolo))
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.konservitajShanghighis,
			object: datumaro.konservitaj
		)
	}
	
	/// Malkonservas la artikolon
	func malkonservi(artikolon artikolo: Artikolo) {
		guard let indekso = datumaro.konservitaj.firstIndex(
			where: { $0.indekso == artikolo.indekso }
		) else { return }
		
		datumaro.konservitaj.remove(at: indekso)
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.konservitajShanghighis,
			object: datumaro.konservitaj
		)
	}
	
	/// Forigas ĉiujn konservitajn artikolojn
	func nuligiKonservitajn() {
		datumaro.konservitaj = []
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.konservitajShanghighis,
			object: datumaro.konservitaj
		)
	}
	
	// MARK: - Stilo
	
	/// Metas la stilon al la apo
	func meti(stilon stilo: InterfacStilo) {
		datumaro.stilo = stilo
		traktilo.skribi(datumaron: datumaro)
		
		NotificationCenter.default.post(
			name: Avizoj.stiloShanghighis,
			object: stilo
		)
	}
}
