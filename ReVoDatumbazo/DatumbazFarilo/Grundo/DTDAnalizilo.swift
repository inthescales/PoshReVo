import Foundation
import CoreData

import ReVoModelojOSX

enum DTDAnalizilo {
	/// Legas entojn (entities) el .dtd-a dosiero
	static func entoj(el indikilo: String) -> [String: String] {
		// XXX: Plie bone evektive analizi DTD-dosieron kiel struktur-havan dokumenton.
		// Tamen, ŝajne la Swift-a XMLParser ne kapablas, do nuntempe, mi uzas regex-ojn.
		
		var entoj: [String: String] = [:]
		
		var teksto = try! String(contentsOf: URL(fileURLWithPath: indikilo), encoding: .utf8)
		
		// Forigi komentojn
		let kontraukomenta = try! Regex("<!--\\s*(.|[\\n\\r])*?\\s*-->")
		teksto = teksto.replacing(kontraukomenta) { _ in "" }
		
		// Kelkajn signojn estas reprezentata kiel kombinaĵo de du kodoj.
		// Tiujn ni konservu ĝisfine, kiam aliaj signoj estos konataj
		var kombinaj: [String: String] = [:]
		
		// Registri entojn
		let regex = try! Regex("<!ENTITY\\s*([\\S_]*?)\\s*\"(.*?)\">")
		teksto.matches(of: regex).forEach { match in
			if match.output.count > 2 {
				let nomTeksto = String(match.output[1].substring!)
				let kodTeksto = String(match.output[2].substring!)
				
				if kodTeksto.signo(0) == "&" 
					&& kodTeksto.signo(kodTeksto.count - 1) == ";" {
					if kodTeksto.lastIndex(of: "&") == kodTeksto.startIndex {
						entoj[nomTeksto] = Interpreti.unikodon(html: kodTeksto.sub(de: 1, al: kodTeksto.count - 1))
					} else {
						kombinaj[nomTeksto] = kodTeksto
					}
				} else {
					entoj[nomTeksto] = kodTeksto
				}
			}
		}
		
		// Aldoni signo-kombinaĵojn
		for (indekso, kodoj) in kombinaj {
			let subRegex = try! Regex("&(.*?);")
			entoj[indekso] = kodoj.matches(of: subRegex).map { submatch in
				let subkodTeksto = String(submatch.output[1].substring!)
				return entoj[subkodTeksto]!
			}
			.reduce("", +)
		}
		
		return entoj
	}
}
