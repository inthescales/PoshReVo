import Foundation

enum Posttraktado {
	/// Efektivigas tiujn ŝanĝojn al artikolo kiuj ne eblas fari dum unuopa legado
	static func postTrakti(artikolon artikolo: Artikolo, markSencoj: [String: Int]) -> Artikolo {
		func anstataui(en teksto: String) -> String {
			let regex = try! Regex("<sncref mrk=\"(.*?)\"\\/>")
			return teksto.replacing(regex) { (match: Regex.Match) in
				let marko = String(match.output[1].substring!)
				if let indekso = markSencoj[marko] {
					return "<sup>\(indekso)</sup>"
				} else {
					// TODO: Konstatu ke ĉiuj markoj estos trovataj
					// assert(false, "Ne trovis markon")
					return ""
				}
			}
		}
		
		var novajBlokoj: [ArtikolBloko] = []
		for bloko in artikolo.blokoj {
			let novaBloko: ArtikolBloko
			switch bloko {
			case .dividila(let teksto):
				novaBloko = .dividila(teksto: anstataui(en: teksto))
			case .derivajhTitola(let teksto, let ofc, let marko):
				novaBloko = .derivajhTitola(teksto: anstataui(en: teksto), ofc: ofc, marko: marko)
			case .teksta(let teksto):
				novaBloko = .teksta(teksto: anstataui(en: teksto))
			case .traduka(let tradukoj):
				let novajTradukoj = tradukoj.map { Traduko(lingvo: $0.lingvo, teksto: anstataui(en: $0.teksto)) }
				novaBloko = .traduka(tradukoj: novajTradukoj)
			}
			
			novajBlokoj.append(novaBloko)
		}
		
		return artikolo.kopio(blokoj: novajBlokoj)
	}
}

private extension Artikolo {
	func kopio(blokoj: [ArtikolBloko]) -> Artikolo {
		return Artikolo(
			titolo: self.titolo,
			radiko: self.radiko,
			indekso: self.indekso,
			ofc: self.ofc,
			blokoj: blokoj
		)
	}
}
