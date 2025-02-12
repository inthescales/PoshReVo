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
	
	lazy var rezulto = Artikolaro.legi(
		el: pakajho.resourcePath! + "/",
		   grundo: grundo
	   )

	/// Testi artikol-tekstojn, inkluzive artikolajn tradukojn
    func testiArtikolon() throws {
		for artikolo in rezulto.artikoloj {
			assertSnapshot(matching: artikolo, as: .json, named: artikolo.titolo)
		}
    }
	
	/// Testi serch-tradukojn
	func testiSerchTradukojn() throws {
		for artikolo in rezulto.artikoloj {
			assertSnapshot(matching: rezulto.tradukoj, as: .json, named: artikolo.titolo)
		}
	}
}
