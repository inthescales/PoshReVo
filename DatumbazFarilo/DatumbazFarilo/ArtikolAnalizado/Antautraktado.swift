import AppKit
import Foundation

enum Antautraktado {
	/// Signoj kiuj ne povas aperi en XML-dosiero
	static let kontrauleghaj = ["&", "<", ">", "\""]
	
	/// Kodoj kiuj uziĝas en artikoloj, tamen mi ne scias kie ĝi difiniĝas
	static let specialaj = [
		"Z": "Zamenhof"
	]
	
	/// Efikas ŝanĝojn en la XML-an tekston antaŭ ke ĝi estos analizita.
	/// Aŭ la Swift-a `XMLParserDelegate` ne bone traktas liter-kodojn, aŭ mi ne komprenas kiel ĝi funkcias.
	/// Iukaze, ĉi tie ni anstataŭas la literkodojn per siaj literoj
	static func antautrakti(tekston teksto: String, literoj: [String: String]) -> String {
		var rezulto = teksto
		
		let regex = try! Regex("&(.*?);")
		rezulto = rezulto.replacing(regex) { (match: Regex.Match) in
			let kodo = String(match.output[1].substring!)
			if let litero = literoj[kodo] {
				if kontrauleghaj.contains(litero) {
					return String("&" + match.output[1].substring! + ";")
				} else {
					return litero
				}
			} else if let teksto = specialaj[kodo] {
				return teksto
			}  else if let signo = hexAlUnikodo(kodo) {
				return signo
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
