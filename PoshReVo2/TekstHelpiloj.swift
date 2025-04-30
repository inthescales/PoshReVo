enum tekstHelpiloj {
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
}
