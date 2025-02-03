import AppKit
import Foundation

enum Antautraktado {
	/// Signoj kiuj ne povas aperi en XML-dosiero
	static let rezervitaj = ["amp", "gt", "lt", "quot"]
	
	/// Efikas ŝanĝojn en la XML-an tekston antaŭ ke ĝi estos analizita.
	/// Aŭ la Swift-a `XMLParserDelegate` ne bone traktas liter-kodojn, aŭ mi ne komprenas kiel ĝi funkcias.
	/// Iukaze, ĉi tie ni anstataŭas la literkodojn per siaj literoj
	static func antautrakti(
		tekston teksto: String,
		literoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) -> String {
		var rezulto = teksto
		
		let regex = try! Regex("&(.*?);")
		rezulto = rezulto.replacing(regex) { (match: Regex.Match) in
			let kodo = String(match.output[1].substring!)
			if let litero = literoj[kodo] {
				return litero
			} else if let mll = mallongigoj[kodo] {
				return mll
			} else if let url = urloj[kodo] {
				return url
			} else if let signo = decAlUnikodo(kodo) {
				return signo
			} else if let signo = hexAlUnikodo(kodo) {
				return signo
			} else if rezervitaj.contains(kodo) {
				return kodo
			} else {
				return ""
			}
		}
		
		// Certigi ke estas spaco inter ekzemploj
		// Nur necesas dum artikol-analizado konstruas tekston paŝ-post-paŝe, sen intertempa
		// strukturo.
		rezulto = rezulto.replacingOccurrences(of: "</ekz><ekz>", with: "</ekz> <ekz>")
		
		return rezulto
	}
}
