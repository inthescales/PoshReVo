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

/// Oficialeco, en la formo per kiu ĝi estu konserivita en ofcvortoj
func konserOficialeco(ofc: String?) -> String {
	switch ofc {
	case nil:
		return "n"
	case "*", "1", "2", "3", "4", "5", "6", "7", "8", "9":
		return ofc!
	default:
		return "a"
	}
}

func subsencLitero(por numero: Int) -> String? {
	let aboco = "abcdefghijklmnoprstuvz"
	guard numero < aboco.count else {
		return nil
	}
	
	let indekso = aboco.index(aboco.startIndex, offsetBy: numero - 1)
	return String(aboco[indekso])
}

func romajCiferoj(por nombro: Int) -> String {
	let arabaj = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
	let romiaj = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
			
	var rezulto = ""
	var komenca = nombro
		
	for j in 0..<romiaj.count {
		let litero = romiaj[j]
		let arabaSumo = arabaj[j]
		let div = komenca / arabaSumo
		
		if div > 0 {
			for i in 0..<div {
				rezulto += litero
			}
			
			komenca -= arabaSumo * div
		}
	}

	return rezulto
}

/// Liveras tekston, ĝuste kiel ĝi aperu en artikolo, por ĉiuj tradukoj de unu lingvo
func prepariTradukTekstojn(tradukoj: [ArtikolTraduko]) -> String {
	var teksto = ""
	
	var montriSencon = false
	var montriSubsencon = false
	
	for i in 0 ..< tradukoj.count {
		
		let nuna = tradukoj[i]
		let lasta = (i > 0) ? tradukoj[i-1]: nil
		if lasta != nil && lasta?.nomo != nuna.nomo {
			montriSencon = false
			montriSubsencon = false
		}

		for j in (i + 1) ..< tradukoj.count {
			let nunnuna = tradukoj[j]
			if nuna.nomo != nunnuna.nomo {
				break
			}
			else if nuna.senco != nunnuna.senco {
				montriSencon = true
				break
			} else if nuna.subsenco != nunnuna.subsenco {
				montriSubsencon = true
				break
			}
		}
		
		if lasta == nil ||
			lasta?.nomo != nuna.nomo ||
			lasta?.senco != nuna.senco ||
			lasta?.subsenco != nuna.subsenco {
			if !teksto.isEmpty {
				teksto += "; "
			}
			teksto += "<a href=\"" + nuna.marko + "\">" + nuna.nomo
			if montriSencon || montriSubsencon, 
				let senco = nuna.senco, senco > 0 {
				teksto += " " + String(senco)
			}
			if montriSubsencon,
			   let subsenco = nuna.subsenco,
			   let litero = subsencLitero(por: subsenco) {
				teksto += "." + litero
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
