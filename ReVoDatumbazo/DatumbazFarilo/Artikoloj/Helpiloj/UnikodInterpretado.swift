/// Helpiloj ĉe interpretadoj de tekstoj en datumaj dosieroj
enum Interpreti {
	/// Interpreti unikodan signon el HTMLa teksto. Teksto devas komenci per '#' (kaj poste 'x' se deksesuma).
	/// Ĝi tamen NE inkluzivu komencan '&' kaj finan ';'.
	static func unikodon(html teksto: String) -> String? {
		guard teksto.count > 1
				&& teksto.sub(de: 0, al: 1) == "#"
		else {
			return nil
		}
		
		if teksto.sub(de: 1, al: 2) == "x" {
			let nombro = teksto.sub(de: 2, al: teksto.count)
			return unikodon(deksesuma: nombro)
		} else {
			let nombro = teksto.sub(de: 1, al: teksto.count)
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
