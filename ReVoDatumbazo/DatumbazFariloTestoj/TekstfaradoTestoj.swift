import XCTest
import SnapshotTesting

@testable import DatumbazFarilo

/// Testoj pri datumbaz-farado
final class TekstfaradoTestoj: XCTestCase {
	/// Testi ke romaj ciferoj estas ĝuste faritaj laŭ numero
	func testiRomajCiferoj() throws {
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 1), "I")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 2), "II")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 3), "III")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 4), "IV")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 5), "V")
		
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 8), "VIII")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 9), "IX")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 10), "X")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 11), "XI")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 12), "XII")
		
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 20), "XX")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 22), "XXII")
		
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 41), "XLI")
		XCTAssertEqual(ArtikolTeksto.romajCiferoj(por: 50), "L")
	}
}
