import XCTest
import SnapshotTesting

@testable import DatumbazFarilo
import ReVoModelojOSX

final class DatumbazFariloTestoj: XCTestCase {
	let pakajho = Bundle(for: DatumbazFariloTestoj.self)
	
	lazy var grundo = {
		let indikilo = pakajho.url(forResource: "grundo", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONDecoder().decode(Grundo.self, from: datumoj)
	}()

    func testiArtikolon() throws {
		let rezulto = Artikolaro.legi(
			el: pakajho.resourcePath! + "/",
			lingvoj: grundo.lingvoj,
			stiloj: grundo.stiloj,
			signoj: grundo.signoj,
			mallongigoj: grundo.mallongigojVerkaj,
			urloj: grundo.urloj
		)
		
		for artikolo in rezulto.artikoloj {
			assertSnapshot(matching: artikolo, as: .json, named: artikolo.titolo)
		}
    }
}
