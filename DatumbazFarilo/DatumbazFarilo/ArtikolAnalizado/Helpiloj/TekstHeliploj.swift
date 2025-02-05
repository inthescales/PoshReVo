import Foundation

/// Helpiloj kiuj faras kaj formas tekstojn tiel kiel ĝi aperu en artikoloj
enum ArtikolTeksto {
	// MARK: - Simboloj kaj sekcio-etikedoj
	
	/// Litero aperonta antaŭ suberivaĵo (ekz. "A.", "B.", ktp.)
	static func subdrvLitero(por numero: Int) -> String? {
		return subsencLitero(por: numero)?.uppercased()
	}
	
	/// Litero aperonta antaŭ subsenco (ekz. "a.", "b.", ktp.)
	static func subsencLitero(por numero: Int) -> String? {
		let aboco = "abcdefghijklmnoprstuvz"
		guard numero < aboco.count else {
			return nil
		}
		
		return aboco.signo(numero - 1)
	}
	
	/// Romaj cierfoj kiel ĝi aperu antaŭ subartikoloj (ekz. "I.", "II.", ktp.)
	static func romajCiferoj(por nombro: Int) -> String {
		let arabaj = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
		let romiaj = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
		
		var rezulto = ""
		var komenca = nombro
		
		for j in 0..<romiaj.count {
			let litero = romiaj[j]
			let arabaSumo = arabaj[j]
			let div = komenca / arabaSumo
			
			if div > 0 {
				rezulto += litero
				komenca -= arabaSumo * div
			}
		}
		
		return rezulto
	}
	
	/// Oficialeco, en la formo per kiu ĝi estu konserivita en ofcvortoj
	static func konservOficialeco(ofc: String?) -> String {
		switch ofc {
		case nil:
			return "n"
		case "*", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			return ofc!
		default:
			return "a"
		}
	}
	
	/// Simbolo kiuj aperu antaŭ referenco, aŭ grupo da referencoj.
	static func refSimbolo(tipo: String) -> String? {
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
	
	/// Teksto uzota kiel serĉindekso kiam `<mll>` aperas.
	static func mllTeksto(baza: String, tipo: String?) -> String {
		switch tipo {
		case "kom":
			return baza + "…"
		case "mez":
			return "…" + baza + "…"
		case "fin":
			return "…" + baza
		case nil:
			return baza
		default:
			assert(false, "Neatendita tipo")
			return ""
		}
	}
	
	// MARK: - Formatoj
	
	/// Liveras tekston, ĝuste kiel ĝi aperu en artikolo, por ĉiuj tradukoj de unu lingvo
	static func tradukTeksto(por: [ArtikolTraduko]) -> String {
		var teksto = ""
		
		var montriSencon = false
		var montriSubsencon = false
		
		for i in 0 ..< por.count {
			
			let nuna = por[i]
			let lasta = (i > 0) ? por[i-1]: nil
			if lasta != nil && lasta?.nomo != nuna.nomo {
				montriSencon = false
				montriSubsencon = false
			}
			
			for j in (i + 1) ..< por.count {
				let nunnuna = por[j]
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
}
