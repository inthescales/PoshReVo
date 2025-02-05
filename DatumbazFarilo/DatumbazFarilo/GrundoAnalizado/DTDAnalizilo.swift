import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

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
		
		// Registri entojn
		let regex = try! Regex("<!ENTITY\\s*([\\S_]*?)\\s*\"(.*?)\">")
		teksto.matches(of: regex).forEach { (match: Regex.Match) in
			if match.output.count > 2 {
				if let signo = Interpreti.unikodon(html: String(match.output[2].substring!)) {
					entoj[String(match.output[1].substring!)] = signo
				} else {
					entoj[String(match.output[1].substring!)] = String(match.output[2].substring!)
				}
			}
		}
		
		return entoj
	}
}
