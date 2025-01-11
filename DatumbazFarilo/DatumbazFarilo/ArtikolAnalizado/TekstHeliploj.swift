import Foundation

func prepari(tekston teksto: String) -> String {
	var rezulto = teksto.replacingOccurrences(of: "\n", with: " ")
	rezulto = rezulto.replacingOccurrences(of: "\r", with: " ")
	rezulto = rezulto.replacingOccurrences(of: "\t", with: "")
	rezulto = rezulto.replacingOccurrences(of: "<em>", with: "<b>")
	rezulto = rezulto.replacingOccurrences(of: "</em>", with: "</b>")
	rezulto = rezulto.replacingOccurrences(of: "...", with: "…")
	
	return rezulto
}

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

extension String {
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
