import ReVoDatumbazo

final class UzantDatumaro {
	static var komuna: UzantDatumaro = {
		elKonservitajAgordoj()
	}()
	
	var lingvoj: [Lingvo]
	
	init(lingvoj: [Lingvo]) {
		self.lingvoj = lingvoj
	}
	
	func redaktisLingvojn(novaj: [Lingvo]) {
		lingvoj = novaj
	}
	
	static func elKonservitajAgordoj() -> UzantDatumaro {
		return UzantDatumaro(
			lingvoj: [Lingvo.esperanto, Lingvo(kodo: "en", nomo: "angla")]
		)
	}
}
