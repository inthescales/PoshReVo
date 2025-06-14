enum TekstHelpiloj {
	// Aldoni chapelon aŭ hokon al litero, se tio kreus esperantan literon
	static func iksumi(_ litero: Character) -> Character? {
		let paroj: [Character: Character] = [
			"c": "ĉ",
			"C": "Ĉ",
			"g": "ĝ",
			"G": "Ĝ",
			"h": "ĥ",
			"H": "Ĥ",
			"j": "ĵ",
			"J": "Ĵ",
			"s": "ŝ",
			"S": "Ŝ",
			"u": "ŭ",
			"U": "Ŭ"
		]

		return paroj[litero]
	}
	
	/// Aldonas ĉapelon aŭ hokon al finan literon se eblas, kaj liveras la ĉenon nur se io ŝanĝiĝis
	static func iksumiFinan(_ teksto: String) -> String? {
		if let lasta = teksto.last,
		   let chapelita = iksumi(lasta) {
			return teksto.prefix(teksto.count - 1) + String(chapelita)
		}
		
		return nil
	}
	
	/// Liveras indican signon por cifero
	static func indico(por nombro: Int) -> Character? {
		let indicoj = [
			0: Character("⁰"),
			1: Character("¹"),
			2: Character("²"),
			3: Character("³"),
			4: Character("⁴"),
			5: Character("⁵"),
			6: Character("⁶"),
			7: Character("⁷"),
			8: Character("⁸"),
			9: Character("⁹")
		]
		
		return indicoj[nombro]
	}
	
	/// Liveras indico-ĉenon por senco, oficialeco, ks
	static func indico(por cheno: String) -> String? {
		if cheno == "*" {
			return "*"
		}
			
		let ciferoj = "0123456789"
		if cheno.allSatisfy({ signo in ciferoj.contains(signo) }) {
			let signoj = cheno.compactMap { signo in
				signo.wholeNumberValue.flatMap { cifero in indico(por: cifero) }
			}
			return String(signoj)
		}
		
		return nil
	}
}
