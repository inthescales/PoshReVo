import XCTest

@testable import DatumbazFarilo
import ReVoModelojOSX

final class DatumbazFariloTestoj: XCTestCase {
	let pakajho = Bundle(for: DatumbazFariloTestoj.self)
	
	lazy var lingvoj = {
		let indikilo = pakajho.url(forResource: "lingvoj", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		let json = try! JSONSerialization.jsonObject(with: datumoj) as! [[String: String]]
		return json.map { Lingvo(kodo: $0["kodo"]!, nomo: $0["nomo"]!)}
	}()
	
	lazy var stiloj = {
		let indikilo = pakajho.url(forResource: "stiloj", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		let json = try! JSONSerialization.jsonObject(with: datumoj) as! [[String: String]]
		return json.map { Stilo(kodo: $0["kodo"]!, nomo: $0["nomo"]!)}
	}()
	
	lazy var signoj = {
		let indikilo = pakajho.url(forResource: "signoj", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONSerialization.jsonObject(with: datumoj) as! [String: String]
	}()
	
	lazy var mallongigoj = {
		let indikilo = pakajho.url(forResource: "mallongigoj", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONSerialization.jsonObject(with: datumoj) as! [String: String]
	}()
	
	lazy var urloj = {
		let indikilo = pakajho.url(forResource: "urloj", withExtension: "json")!
		let datumoj = try! Data(contentsOf: indikilo)
		return try! JSONSerialization.jsonObject(with: datumoj) as! [String: String]
	}()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
		let dosieroj = try! FileManager.default.contentsOfDirectory(atPath: pakajho.resourcePath!)
			.filter { $0.hasSuffix(".xml") }
		
//		_ = Artikolaro.legi(
//			el: pakajho.resourcePath!,
//			lingvoj: lingvoj,
//			stiloj: stiloj,
//			signoj: signoj,
//			mallongigoj: mallongigoj,
//			urloj: urloj
//		)
    }
}
