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
		
		// anstataŭi <em> etikedoj per <b>
		rezulto = rezulto.replacingOccurrences(of: "<em>", with: "<b>")
		rezulto = rezulto.replacingOccurrences(of: "</em>", with: "</b>")
		
		// Uzi tripunktan signon anstataŭ tri punktojn
		rezulto = rezulto.replacingOccurrences(of: "...", with: "…")
		
		return rezulto
	}
	
	/// Forigi komencajn kaj finajn spacojn
	func tondi() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
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
}
