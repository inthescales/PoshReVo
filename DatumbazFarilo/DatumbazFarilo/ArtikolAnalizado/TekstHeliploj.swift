import Foundation

func refSimbolo(tipo: String) -> String? {
	switch tipo {
	case "sin":
		return "⇒"
	case "ant":
		return "⇝"
	case "dif":
		return "="
	case "super":
		return "⇗"
	case "sub":
		return "⇘"
	case "vid":
		return "➞"
	case "ekz":
		return "⇉"
	case "prt":
		return nil
	case "malprt":
		return nil
	default:
		return nil
	}
}

/// Liveras tekston, ĝuste kiel ĝi aperu en artikolo, por ĉiuj tradukoj de unu lingvo
func prepariTradukTekstojn(tradukoj: [ArtikolTraduko]) -> String {
	var teksto = ""
	
	var montriSencon = false
	
	for i in 0 ..< tradukoj.count {
		
		let nuna = tradukoj[i]
		let lasta = (i > 0) ? tradukoj[i-1]: nil
		if lasta != nil && lasta?.nomo != nuna.nomo { montriSencon = false}

		for j in (i + 1) ..< tradukoj.count {
			let nunnuna = tradukoj[j]
			if nuna.nomo != nunnuna.nomo {
				break
			}
			else if nuna.senco != nunnuna.senco {
				montriSencon = true
				break
			}
		}
		
		if lasta == nil ||
			lasta?.nomo != nuna.nomo ||
			lasta?.senco != nuna.senco {
			if !teksto.isEmpty {
				teksto += "; "
			}
			teksto += "<a href=\"" + nuna.marko + "\">" + nuna.nomo
			if montriSencon, let senco = nuna.senco, senco > 0 {
				teksto += " " + String(senco)
			}
			teksto += "</a>: "
		} else {
			teksto += ", "
		}
		teksto += nuna.teksto
	}
	
	teksto += "."
	
	return teksto
}

extension String {
	func prepari() -> String {
		var rezulto = self.replacingOccurrences(of: "\n", with: " ")
		rezulto = rezulto.replacingOccurrences(of: "\r", with: " ")
		rezulto = rezulto.replacingOccurrences(of: "\t", with: "")
		rezulto = rezulto.replacingOccurrences(of: "<em>", with: "<b>")
		rezulto = rezulto.replacingOccurrences(of: "</em>", with: "</b>")
		rezulto = rezulto.replacingOccurrences(of: "...", with: "…")
		
		return rezulto
	}
	
	func tondi() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	func kunpremi(_ simbolo: Character) -> String {
		var rezulto = ""
		
		var lasta: Character? = nil
		for char in self {
			if char == simbolo,
			   char == lasta {
				continue
			} else {
				rezulto += String(char)
				lasta = char
			}
		}
		
		return rezulto
	}
}
