import Foundation

import ReVoDatumbazo

extension Avizoj {
	static let elektitaLingvoShanghighis = NSNotification.Name("elektitaLingvoShanghighis")
	static let uzantajLingvojShanghighis = NSNotification.Name("uzantajLingvojShanghighis")
}

final class UzantDatumaro {
	static var komuna: UzantDatumaro = {
		elKonservitajAgordoj()
	}()
	
	var elektitaLingvo: Lingvo
	
	var lingvoj: [Lingvo]
	
	init(lingvoj: [Lingvo]) {
		self.elektitaLingvo = lingvoj.first!
		self.lingvoj = lingvoj
	}
	
	func elektis(lingvon novaLingvo: Lingvo) {
		elektitaLingvo = novaLingvo
		NotificationCenter.default.post(name: Avizoj.elektitaLingvoShanghighis, object: novaLingvo)
	}
	
	func redaktisLingvojn(novaj: [Lingvo]) {
		lingvoj = novaj
		NotificationCenter.default.post(name: Avizoj.uzantajLingvojShanghighis, object: lingvoj)
	}
	
	static func elKonservitajAgordoj() -> UzantDatumaro {
		return UzantDatumaro(
			lingvoj: [Lingvo.esperanto, Lingvo(kodo: "en", nomo: "angla")]
		)
	}
}
