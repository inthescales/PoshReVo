import Foundation

/// Kolektas literojn kaj siajn kodojn el la XMLa dosiero
/// Collects letters and their codes from the XML file
class LiteroAnalizilo : NSObject, XMLParserDelegate {
	var literoj: [String: String] = [:]
	private var atendas: [String: [String]] = [:]
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Eklegas literojn")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finlegis literojn")
		kompletigi()
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "l",
		    let nomo = attributeDict["nomo"],
			let kodo = attributeDict["kodo"] {
			if kodo[..<kodo.index(kodo.startIndex, offsetBy: 2)] == "#x" {
				// Ĉi-kodoj indikas unikodajn signonumerojn de la signoj
				// These codes indicate Unicode code-points of the characters
				// ekz: Ecirc = #x00ca = Ê
				let signoKodo = kodo[kodo.index(kodo.startIndex, offsetBy: 2)...]
				let signo = String(UnicodeScalar(UInt32(signoKodo, radix: 16)!)!)
				literoj[nomo] = signo
				trovis(litero: nomo, signo: signo)
			} else if kodo.count > 5
						&& kodo[..<kodo.index(kodo.startIndex, offsetBy: 5)] == "#38;#" {
				// Ĉi-kodoj havas ŝajne ne-uzatan "#38" komence, kaj poste validan ASCII-kodon
				// These codes have a seeminly unused '#38' at the start, then afterwards a valid ASCII code
				let signoKodo = kodo[kodo.index(kodo.startIndex, offsetBy: 5)...]
				let signo = String(UnicodeScalar(UInt32(signoKodo)!)!)
				literoj[nomo] = signo
				trovis(litero: nomo, signo: signo)
			} else if kodo[..<kodo.index(kodo.startIndex, offsetBy: 1)] == "#" {
				// Ĉi-kodoj estas validaj ASCIIaj signo-kodoj
				// These codes are valid ASCII character codes
				let signoKodo = kodo[kodo.index(kodo.startIndex, offsetBy: 1)...]
				let signo = String(UnicodeScalar(UInt32(signoKodo)!)!)
				literoj[nomo] = signo
				trovis(litero: nomo, signo: signo)
			} else if kodo.contains(";") {
				// Kelkaj kodoj konsistas el pluraj kodoj kunigitaj
				// Some codes are made up of multiple combined codes
				let elementoj = kodo.components(separatedBy: ";")
				
				var rezulto = ""
				for elemento in elementoj {
					if elemento == "&amp" {
						// Ĉi-elemento ŝajne ne reprezentiĝas en fina rezulto
						// This element apparently doesn't appear in the final result
						continue
					} else if literoj[elemento] != nil {
						rezulto += literoj[elemento] ?? ""
					}
				}
				literoj[nomo] = rezulto
				
				// AVERTO: rimarku ke ne eblas antendi solvon de jam-ne-renkontita litero en kazoj de plurpartaj kombinoj. Ĝis nun, tio ne estas problema, ĉar ĉi-tiaj plurliteraj kombinoj nur okazas en tri kazoj, je kiuj ĉiuj eroj jam estas difinitaj.
				// WARNING: note that it is not possible to wait for a code to be resolved if it is part of a multi-character combination here. This is currently not a problem, as these multi-part combinations only occur in three cases, and in each all contained elements are already defined.
			} else {
				// Kelkaj kodoj indikas nomojn de aliaj literoj
				// Some codes indicate the names of other letters
				if literoj[kodo] != nil {
					literoj[nomo] = literoj[kodo]
				} else {
					// Se ĉi-litero jam ne troviĝas, aldoni al atendo-listo
					// If this letter hasn't been found, add it to waiting list
					if atendas[kodo] == nil {
						atendas[kodo] = [nomo]
					} else {
						atendas[kodo]?.append(nomo)
					}
				}
			}
		}
	}
	
	// MARK: - Helpiloj
	
	/// Vokota post ĉiu nova liter-aldono. Traktas ajnajn literojn kiuj atendas tiu litero.
	/// Called after each new letter. Handles any letters that were waiting for that letter.
	private func trovis(litero: String, signo: String) {
		for nomo in atendas[litero] ?? [] {
			literoj[nomo] = signo
		}
		atendas[litero] = nil
	}
	
	/// Aldonas plurajn mankantajn literojn
	/// Add a few missing letters
	private func kompletigi() {
		// FARENDA: Konfirmu ĉu ia korekto indas ReVo-flanke (ĉu aldoni literojn ĉu korekti uzadon)
		// TODO: Check whether a correction is needed on the ReVo side (whether adding letters or correcting usage)
		literoj["a_a"] = literoj["a_A"]
		literoj["a_fatha_a"] = literoj["a_fatha_A"]
	}
}

// MARK: - Vokilo

extension LiteroAnalizilo {
	/// Legas literojn el la donata indikilo kaj liveras ilin kun siaj kodoj
	/// Reads abbreviations from the given file path and returns them with their codes
	public static func legi(el indikilo: String) -> [String: String] {
				
		let literoAnalizilo = LiteroAnalizilo()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = literoAnalizilo
		analizilo.parse()
		
		return literoAnalizilo.literoj
	}
}
