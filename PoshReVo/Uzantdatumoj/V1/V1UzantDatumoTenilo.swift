import Foundation

import ReVoDatumbazo

final class V1UzantDatumoTenilo {
	private enum Klavoj {
		static let serchLingvo = "serchLingvo"
		static let oftajSerchLingvoj = "oftajSerchLingvoj"
		static let tradukLingvoj = "tradukLingvoj"
		static let historio = "historio"
		static let konservitaj = "konservitaj"
	}
	
	private static var defaultaStilo: InterfacStilo = .defaulta
	
	/// Legas datumojn skribitajn de V1 de la apo
	static func legiV1Datumaron() -> UzantDatumaro? {
		let defaults = UserDefaults.standard
		
		NSKeyedUnarchiver.setClass(Lingvo.self, forClassName: "ReVoModeloj.Lingvo")
		NSKeyedUnarchiver.setClass(Listero.self, forClassName: "PoshReVo.Listero")
		
		var serchLingvo: Lingvo?
		if let datumoj = defaults.object(forKey: Klavoj.serchLingvo) as? Data,
		   let trovo = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [Lingvo.self, NSString.self], from: datumoj) as? Lingvo {
			serchLingvo = trovo
		}

		var oftajSerchLingvoj: [Lingvo] = []
		if let datumoj = defaults.object(forKey: Klavoj.oftajSerchLingvoj) as? Data,
		   let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Lingvo] {
			oftajSerchLingvoj = trovo
		}

		var tradukLingvoj: [Lingvo] = []
		if let datumoj = defaults.object(forKey: Klavoj.tradukLingvoj) as? Data,
		   let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Lingvo] {
			tradukLingvoj = trovo
		}
		
		var historio: [Konservitajho] = []
		if let datumoj = defaults.object(forKey: Klavoj.historio) as? Data,
			let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Listero] {
			historio = trovo.map { Konservitajho(nomo: $0.nomo, indekso: $0.indekso) }
		}

		var konservitaj: [Konservitajho] = []
		if let datumoj = defaults.object(forKey: Klavoj.konservitaj) as? Data,
		   let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Listero] {
			konservitaj = trovo.map { Konservitajho.el(v1Listero: $0) }
		}
		
		// Kunigi lingvojn, forigi duoblaĵojn
		// TODO: Kiam Lingvo estos denove strukto, plisimpligi senduoblaĵigadon
		var chiujLingvoj: [Lingvo] = []
		([serchLingvo] + oftajSerchLingvoj + tradukLingvoj)
			.compactMap { $0 }
			.forEach { lingvo in
				if !chiujLingvoj.map({ $0.nomo }).contains(lingvo.nomo) {
					chiujLingvoj.append(lingvo)
				}
		}
		
		guard chiujLingvoj.count > 0,
			  let unuaLingvo = chiujLingvoj.first else {
			return nil
		}
		
		return UzantDatumaro(
			elektitaLingvo: serchLingvo ?? unuaLingvo,
			lingvoj: chiujLingvoj,
			historio: historio,
			konservitaj: konservitaj,
			stilo: defaultaStilo
		)
	}
}
