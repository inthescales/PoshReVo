import XCTest
import SnapshotTesting

@testable import DatumbazFarilo

/// Testoj pri datumbaz-farado
final class DatumbazFariloTestoj: XCTestCase {
	/// Testi artikol-tekstojn, inkluzive artikolajn tradukojn
    func testiArtikolon() throws {
		for rezulto in TestDatumoj.komuna.rezultoj {
			let artikolo = rezulto.artikolo
			assertSnapshot(matching: artikolo, as: .json, named: artikolo.titolo)
		}
    }
	
	/// Testi serch-tradukojn
	func testiSerchTradukojn() throws {
		for rezulto in TestDatumoj.komuna.rezultoj {
			assertSnapshot(matching: rezulto.serchTradukoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi serchvortojn
	func testiSerchVortojn() throws {
		for rezulto in TestDatumoj.komuna.rezultoj {
			assertSnapshot(matching: rezulto.serchVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi fakvortojn
	func testiFakVortojn() throws {
		for rezulto in TestDatumoj.komuna.rezultoj {
			assertSnapshot(matching: rezulto.fakVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi ofcvortojn
	func testiOfcVortojn() throws {
		for rezulto in TestDatumoj.komuna.rezultoj {
			assertSnapshot(matching: rezulto.ofcVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
}
