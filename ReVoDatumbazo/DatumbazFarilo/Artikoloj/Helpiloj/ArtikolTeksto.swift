import Foundation

/// Helpiloj kiuj faras kaj formas tekstojn tiel kiel ĝi aperu en artikoloj
enum ArtikolTeksto {
	// MARK: - Simboloj kaj sekcio-etikedoj
	
	/// Supozante ke la ĉeno estas kapteksto havanta plurajn formojn, liveras array-on da formoj
	static func kapFormoj(por kapTeksto: String) -> [String] {
		return kapTeksto.split(separator: ", ").map { String($0).tondi() }
	}
	
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
		let paroj: [(kvanto: Int, roma: String)] = [
			(1000, "M"),
			(900, "CM"),
			(500, "D"),
			(400, "CD"),
			(100, "C"),
			(90, "XC"),
			(50, "L"),
			(40, "XL"),
			(10, "X"),
			(9, "IX"),
			(5, "V"),
			(4, "IV"),
			(1, "I")
		]
		
		var rezulto = ""
		var valoro = nombro
		
		for paro in paroj {
			while paro.kvanto <= valoro {
				rezulto += paro.roma
				valoro -= paro.kvanto
			}
		}
		
		return rezulto
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
			return baza.tondiFine() + "…"
		case "mez":
			return "…" + baza.tondi() + "…"
		case "fin":
			return "…" + baza.tondiKomence()
		case nil:
			return baza
		default:
			assert(false, "Neatendita tipo")
			return ""
		}
	}
	
	// MARK: - Formatoj

	/// Liveras tekston, ĝuste kiel ĝi aperu en artikolo, por ĉiuj tradukoj de unu lingvo
	static func tradukTeksto(por tradukoj: [ArtikolTraduko]) -> String {
		// TODO: Aldoni koloron al numeroj kaj transpasnomoj
		var teksto = ""
		
		for (i, nuna) in tradukoj.enumerated() {
			let lasta = (i > 0) ? tradukoj[i-1]: nil
						
			var montriSencon = false
			var montriNomon = false
			
			// Montri sencon se 1. la nuna traduko havas malsaman sencon ol lasta,
			// aŭ 2. la nuna traduko havas malsaman sencon ol iu ajn venonta.
			// - 2. necesas por ke tradukoj de la unua senco montru senc-numeron,
			// - 1. necesas por ke tradukoj sekvanta sensencan tradukon montru ĝin
			if nuna.transpasNomo == true && lasta?.nomo != nuna.nomo {
				montriNomon = true
			} else if nuna.senco != nil {
				if let lasta,
				   nuna.senco != lasta.senco {
					montriSencon = true
				} else {
					for estonta in tradukoj[(i + 1)...] {
						if nuna.nomo != estonta.nomo
							&& !estonta.transpasNomo {
							break
						}
						else if nuna.senco != estonta.senco {
							montriSencon = true
							break
						}
					}
				}
			}
			
			if montriNomon {
				teksto += " · " + nuna.nomo + ": "
			} else if let lasta,
					  lasta.transpasNomo == true,
					  lasta.nomo != nuna.nomo,
					  !montriSencon {
				// Aldoni punkton se la antaŭa traduko montris transpasan nomon, kiuj estas
				// alia ol la nuna nomo, kaj ni ne montros senc-numeron.
				// Mi jam ne renkontis ekzemplon de ĉi-situacio, tamen jen mia preparaĵo
				teksto += " · "
			} else if let lasta,
				lasta.nomo == nuna.nomo
				&& lasta.senco == nuna.senco
				&& lasta.subsenco == nuna.subsenco {
				// Aldonu komon se la traduko apartenas al la sama grupo ol la antaŭa
				teksto += ", "
			} else {
				if i > 0 {
					teksto += " "
				}
				
				let montriSubsencon = nuna.subsenco != nil && !nuna.transpasNomo

				if montriSencon || montriSubsencon,
				   let senco = nuna.senco,
				   senco > 0 {
					teksto += String(senco) + "."
				}
				
				// Ĉiam montru subsencon, se ĉeestas
				if montriSubsencon,
				   let subsenco = nuna.subsenco,
				   let litero = subsencLitero(por: subsenco) {
					teksto += litero
				}
				
				if montriSencon || montriSubsencon {
					teksto += " "
				}
			}
			
			teksto += nuna.teksto
		}
		
		return teksto
	}
}
