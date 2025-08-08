import Foundation

import ReVoDatumbazo

struct UzantDatumaro {
	static var komuna: UzantDatumaro {
		UzantDatumoRegilo.komuna.datumaro
	}
	
	var elektitaLingvo: Lingvo
	
	var lingvoj: [Lingvo]
	
	var historio: [Konservitajho]
	
	var konservitaj: [Konservitajho]
	
	var stilo: InterfacStilo
	
	// MARK: - Helpajhoj
	
	func chuKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
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
	
	private static var defaultaStilo: InterfacStilo = .baza
	
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
	
		let stilNomo = try container.decode(String.self, forKey: .stilo)
		stilo = InterfacStilo.chiuj.first(where: { $0.nomo == stilNomo }) ?? Self.defaultaStilo
		
		elektitaLingvo = lingvoj.first!
	}
}
