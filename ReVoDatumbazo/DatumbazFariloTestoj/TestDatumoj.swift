import Foundation

@testable import DatumbazFarilo

final class TestDatumoj {
	static var komuna = TestDatumoj()
	
	static let pakajho = Bundle(for: DatumbazFariloTestoj.self)
	
	lazy var grundo = {
		let indikilo = Self.pakajho.url(forResource: "grundo", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONDecoder().decode(Grundo.self, from: datumoj)
	}()
	
	lazy var rezultoj = {
		let pakajhIndiko = Self.pakajho.resourcePath! + "/"
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
}
