import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

enum DTDAnalizilo {
	/// Legas entojn (entities) el .dtd-a dosiero
	static func entoj(el indikilo: String) -> [String: String] {
		var entoj: [String: String] = [:]
		
		let teksto = try! String(contentsOf: URL(fileURLWithPath: indikilo), encoding: .utf8)

		
		let regex = try! Regex("<!ENTITY (\\w*?) \"(.*?)\">")
		teksto.matches(of: regex).forEach { (match: Regex.Match) in
			if match.output.count > 2 {
				entoj[String(match.output[1].substring!)] = String(match.output[2].substring!)
			}
		}
		
		return entoj
	}
}
