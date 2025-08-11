import AppKit
import Foundation

/// Procezo al kiu bibliografiaj tekstoj estu submetitaj *antaŭ* ol analizado.
enum BibliografioAntautraktado {
	/// Bazita sur la antaŭtraktado de artikoloj
	static func antautrakti(
		tekston teksto: String,
		signoj: [String: String]
	) -> String {
		var rezulto = teksto
		
		// Evitas eraron pro la instrukcio '%signoj;' en la bibliografia XML-dosiero
		// Supozeble ĝi provas importi la signojn, tamen io ne funkcias. Mi ne scias se
		// la kaŭzo estas mia nescio, aŭ eraro en la Swifta- XML-analizilo.
		// Ĉiukaze, mi forigas tiun linion ĉi tie, kaj anstataŭas signojn sube.
		let regex1 = try! Regex("%(.*?);")
		rezulto = rezulto.replacing(regex1) { _ in "" }
		
		// Anstataŭi signojn
		let regex = try! Regex("&(.*?);")
		rezulto = rezulto.replacing(regex) { (match: Regex.Match) in
			let kodo = String(match.output[1].substring!)
			if let signo = signoj[kodo] {
				return signo
			} else if let signo = Interpreti.unikodon(html: kodo) {
				return signo
			} else {
				return ""
			}
		}

		return rezulto
	}
}
