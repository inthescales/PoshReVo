import Foundation
import ReVoModelojOSX

/// Efektivigas tiujn ŝanĝojn al artikolo kiuj ne eblas fari dum unuopa legado
func postTrakti(artikolon artikolo: Artikolo, markSencoj: [String: Int]) -> Artikolo {
	func anstataui(en teksto: String) -> String {
		let regex = try! Regex("<sncref mrk=\"(.*?)\"\\/>")
		return teksto.replacing(regex) { (match: Regex.Match) in
			let marko = String(match.output[1].substring!)
			if let indekso = markSencoj[marko] {
				return "<sup>\(indekso)</sup>"
			} else {
				assert(false, "Ne trovis markon")
			}
		}
	}
	
	var novajSubartikoloj: [Subartikolo] = []
	for subartikolo in artikolo.subartikoloj {
		var novajVortoj: [Vorto] = []
		for vorto in subartikolo.vortoj {
			let novaVorto = vorto.kopio(teksto: anstataui(en: vorto.teksto))
			novajVortoj.append(novaVorto)
		}
		let novaSubartikolo = Subartikolo(
			teksto: anstataui(en: subartikolo.teksto),
			vortoj: novajVortoj
		)
		novajSubartikoloj.append(novaSubartikolo)
	}
	
	return artikolo.kopio(subartikoloj: novajSubartikoloj)
}

private extension Vorto {
	func kopio(teksto: String) -> Vorto {
		return Vorto(
			titolo: self.titolo,
			teksto: teksto,
			marko: self.marko,
			ofc: self.ofc
		)
	}
}

private extension Artikolo {
	func kopio(subartikoloj: [Subartikolo]) -> Artikolo {
		return Artikolo(
			titolo: self.titolo,
			radiko: self.radiko,
			indekso: self.indekso,
			ofc: self.ofc,
			subartikoloj: subartikoloj,
			tradukoj: self.tradukoj
		)
	}
}
