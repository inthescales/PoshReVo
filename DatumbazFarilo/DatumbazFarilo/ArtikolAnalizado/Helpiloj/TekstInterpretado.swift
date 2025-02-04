/// Helpiloj ĉe interpretadoj de tekstoj en datumaj dosieroj
enum Interpreti {
	/// Interpreti unikodan signon el HTMLa teksto. Teksto devas komenci per '#' (kaj poste 'x' se deksesuma),
	/// ĝi tamen NE inkluzivu komencan '&' kaj finan ';'.
	static func unikodon(html teksto: String) -> String? {
		guard teksto.count > 1
				&& teksto[teksto.startIndex..<teksto.index(teksto.startIndex, offsetBy: 1)] == "#"
		else {
			return nil
		}
		
		let dua = teksto[teksto.index(teksto.startIndex, offsetBy: 1)..<teksto.index(teksto.startIndex, offsetBy: 2)]
		
		if dua == "x" {
		   let nombro = String(teksto[teksto.index(teksto.startIndex, offsetBy: 2)..<teksto.endIndex])
		   return unikodon(deksesuma: nombro)
		} else {
			let nombro = String(teksto[teksto.index(teksto.startIndex, offsetBy: 1)..<teksto.endIndex])
			return unikodon(dekuma: nombro)
		}
	}

	/// Liveras unikodan signon representata per la jena dekuma nombro-teksto.
	/// Ekz.: "8230" -> "…"
	static func unikodon(dekuma teksto: String) -> String? {
		let signo = String(UnicodeScalar(UInt32(teksto, radix: 10)!)!)
		return signo
	}

	/// Liveras unikodan signon representata per la jena deksesuma nombro-teksto.
	/// Ekz.: "30C1" -> "チ"
	static func unikodon(deksesuma teksto: String) -> String? {
		let signo = String(UnicodeScalar(UInt32(teksto, radix: 16)!)!)
		return signo
	}
}
