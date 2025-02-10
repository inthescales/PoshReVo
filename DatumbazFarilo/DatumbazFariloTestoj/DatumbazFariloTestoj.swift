import XCTest
import SnapshotTesting

@testable import DatumbazFarilo
import ReVoModelojOSX

/// Testoj pri datumbaz-farado
final class DatumbazFariloTestoj: XCTestCase {
	let pakajho = Bundle(for: DatumbazFariloTestoj.self)
	
	lazy var grundo = {
		let indikilo = pakajho.url(forResource: "grundo", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONDecoder().decode(Grundo.self, from: datumoj)
	}()

	/// Testi legadon de artikoloj, iliajn strukturojn, tekstojn, kaj tradikojn de
    func testiArtikolon() throws {
		let rezulto = Artikolaro.legi(
			el: pakajho.resourcePath! + "/",
			grundo: grundo
		)
		
		for artikolo in rezulto.artikoloj {
			assertSnapshot(matching: artikolo, as: .json, named: artikolo.titolo)
		}
    }
}
