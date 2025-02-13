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
	
	lazy var rezultoj = {
		let pakajhIndiko = pakajho.resourcePath! + "/"
		let dosierNomoj = try! FileManager.default.contentsOfDirectory(atPath: pakajhIndiko)
			.filter { $0.hasSuffix(".xml") }
		
		var rezultoj: [ArtikolAnalizilo.Rezulto] = []
		for dosierNomo in dosierNomoj {
			let novaRezulto = ArtikolAnalizilo.legi(
				el: pakajhIndiko + "/" + dosierNomo,
				grundo: grundo,
				postTrakti: true
			)
			
			rezultoj.append(novaRezulto)
		}
		
		return rezultoj
	}()

	/// Testi artikol-tekstojn, inkluzive artikolajn tradukojn
    func testiArtikolon() throws {
		for rezulto in rezultoj {
			let artikolo = rezulto.artikolo
			assertSnapshot(matching: artikolo, as: .json, named: artikolo.titolo)
		}
    }
	
	/// Testi serch-tradukojn
	func testiSerchTradukojn() throws {
		for rezulto in rezultoj {
			assertSnapshot(matching: rezulto.serchTradukoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi serchvortojn
	func testiSerchVortojn() throws {
		for rezulto in rezultoj {
			assertSnapshot(matching: rezulto.serchVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi fakvortojn
	func testiFakVortojn() throws {
		for rezulto in rezultoj {
			assertSnapshot(matching: rezulto.fakVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
	
	/// Testi ofcvortojn
	func testiOfcVortojn() throws {
		for rezulto in rezultoj {
			assertSnapshot(matching: rezulto.ofcVortoj, as: .json, named: rezulto.artikolo.titolo)
		}
	}
}
