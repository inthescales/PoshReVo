import AppKit
import Foundation

enum Antautraktado {
	/// Kodoj kiuj uziĝas en artikoloj, tamen mi ne scias kie ĝi difiniĝas
	static let specialaj = [
		"Z": "Zamenhof"
	]
	
	/// Efikas ŝanĝojn en la XML-an tekston antaŭ ke ĝi estos analizita.
	/// Aŭ la Swift-a `XMLParserDelegate` ne bone traktas liter-kodojn, aŭ mi ne komprenas kiel ĝi funkcias.
	/// Iukaze, ĉi tie ni anstataŭas la literkodojn per siaj literoj
	static func antautrakti(tekston teksto: String, literoj: [String: String]) -> String {
		let regex = try! Regex("&(.*?);")
		return teksto.replacing(regex) { (match: Regex.Match) in
			let kodo = String(match.output[1].substring!)
			if let litero = literoj[kodo] {
				if litero == "&" {
					// Ne NEPRE ne liveru "&", ĉar XML ne povas enhavi "&"-on, kaj
					// analizado malsukcesos
					return String("&" + match.output[1].substring! + ";")
				} else {
					return litero
				}
			} else if let teksto = specialaj[kodo] {
				return teksto
			} else if let htmlKodon = konverti(htmlKodon: kodo) {
				if htmlKodon == "&\(kodo);" {
					return kodo
				}
				
				return htmlKodon
			} else {
				return ""
			}
		}
	}
	
	/// Legi HTML-kodon, aparte necesa por unikodo-signojn kiuj aperas en tradukoj
	private static func konverti(htmlKodon kodo: String) -> String? {
		guard Thread.isMainThread else {
			assert(false, "Ĉi kodo devas ruliĝi en la ĉefa fadeno")
		}
		
		let data = "&\(kodo);".data(using: .utf8)!

		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]

		let attributedString = try! NSAttributedString(
			data: data,
			options: options,
			documentAttributes: nil
		)

		return attributedString.string
	}
}
