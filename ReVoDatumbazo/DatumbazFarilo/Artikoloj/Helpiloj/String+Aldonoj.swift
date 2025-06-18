/// Helpaj aldonoj al String
extension String {
	/// Efektivigas kelkajn ŝanĝojn taŭgajn por artikol-tekstoj.
	func prepari() -> String {
		var rezulto = self
		
		// Kunigi ĉiujn tekston en unu linio (linioj estos ree apartigitajn alimaniere)
		rezulto = rezulto.replacingOccurrences(of: "\n", with: " ")
		rezulto = rezulto.replacingOccurrences(of: "\r", with: " ")
		
		// Taboj estu forigitajn (dokumentaj marĝenoj ne gravas)
		rezulto = rezulto.replacingOccurrences(of: "\t", with: "")
		
		// Uzi tripunktan signon anstataŭ tri punktojn
		rezulto = rezulto.replacingOccurrences(of: "...", with: "…")
		
		return rezulto
	}
	
	/// Forigi komencajn kaj finajn spacojn
	func tondi() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/// Forigi nur komencajn spacojn
	func tondiKomence() -> String {
		return self.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
	}
	
	/// Forigi nur finajn spacojn
	func tondiFine() -> String {
		return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
	}
	
	/// Forigi apudajn kopiojn de signoj (aparte spacoj), lasante nur unu.
	func kunpremi(_ simbolo: Character = " ") -> String {
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
	
	// MARK: - Subĉenoj
	
	/// Liveras signo je certa indekso
	func signo(_ indekso: Int) -> String {
		sub(de: indekso, al: indekso + 1)
	}
	
	/// Liveras subĉenon ekde la komenco ĝis certa indekso
	func prefikso(ghis longo: Int) -> String {
		sub(de: 0, al: longo)
	}
	
	/// Liveras subĉenon ekde certa loko ĝis la fino
	func sufikso(de komenco: Int) -> String {
		sub(de: komenco, al: count)
	}
	
	/// Liveras subĉenon inter du indeksoj
	func sub(de komencIndekso: Int, al finIndekso: Int) -> String {
		String(self[index(startIndex, offsetBy: komencIndekso)..<index(startIndex, offsetBy: finIndekso)])
	}
}
