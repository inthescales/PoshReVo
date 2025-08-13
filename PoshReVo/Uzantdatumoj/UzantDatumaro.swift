import Foundation

import ReVoDatumbazo

/// La nuna stato de la uzantaj datumoj, agordoj, ktp.
struct UzantDatumaro {
	static var komuna: UzantDatumaro {
		UzantDatumoRegilo.komuna.datumaro
	}
	
	/// Lingvo kiu estas elektita en serĉila lingvoelektilo
	var elektitaLingvo: Lingvo
	
	/// Ĉiuj uzantaj lingvoj, aperantaj en serĉila lingvoelektilo kaj artikolaj tradukaroj
	var lingvoj: [Lingvo]
	
	/// Artikoloj legitaj de la uzanto
	var historio: [Konservitajho]
	
	/// Artikoloj konservitaj de la uzanto
	var konservitaj: [Konservitajho]
	
	/// Stilo de la interfaco
	var stilo: InterfacStilo
	
	// MARK: - Helpajhoj
	
	/// Ĉu tiu lingvo estas konservita
	func chuKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
	}
	
	// MARK: - Defaultaj valoroj
	
	/// Defaŭlta stato de uzantaj datumoj.
	/// Tiel vidos tute nova uzanto la apon.
	static func defaulta() -> UzantDatumaro {
		UzantDatumaro(
			elektitaLingvo: defaultajLingvoj.first!,
			lingvoj: defaultajLingvoj,
			historio: [],
			konservitaj: [],
			stilo: defaultaStilo
		)
	}
	
	/// Defaŭltaj lingvoj. Esperanto, kaj lingvoj de la aparato
	private static var defaultajLingvoj: [Lingvo] {
		let aparatajLingvoj = NSLocale.preferredLanguages.compactMap { kodo in
			let bazo = kodo.components(separatedBy: "-").first
			return VortaroDatumbazo.komuna.lingvo(kodo: bazo ?? kodo)
		}.filter { lingvo in
			lingvo != Lingvo.esperanto
		}
		
		return [.esperanto] + aparatajLingvoj
	}
	
	/// Defaŭlta interfacstilo
	private static var defaultaStilo: InterfacStilo = .simpla
}

// MARK: - Equatable

extension UzantDatumaro: Equatable {
	public static func ==(lhs: UzantDatumaro, rhs: UzantDatumaro) -> Bool {
		return lhs.lingvoj == rhs.lingvoj
			&& lhs.historio == rhs.historio
			&& lhs.konservitaj == rhs.konservitaj
			&& lhs.stilo.identigilo == rhs.stilo.identigilo
	}
}

// MARK: - Codable

extension UzantDatumaro: Codable {
	private enum CodingKeys: String, CodingKey {
		case lingvoj = "lingvoj"
		case historio = "historio"
		case konservitaj = "konservitaj"
		case stilo = "stilo"
	}
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(lingvoj, forKey: .lingvoj)
		try container.encode(historio, forKey: .historio)
		try container.encode(konservitaj, forKey: .konservitaj)
		try container.encode(stilo.identigilo, forKey: .stilo)
	}
	
	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		lingvoj = try container.decode([Lingvo].self, forKey: .lingvoj)
		historio = try container.decode([Konservitajho].self, forKey: .historio)
		konservitaj = try container.decode([Konservitajho].self, forKey: .konservitaj)
	
		let stiloIdentigilo = try container.decode(String.self, forKey: .stilo)
		stilo = InterfacStilo.chiuj.first(where: { $0.identigilo == stiloIdentigilo }) ?? Self.defaultaStilo
		
		elektitaLingvo = lingvoj.first!
	}
}
