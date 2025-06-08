extension Artikolo: CustomStringConvertible {
	public var description: String {
		var rezulto = ""
		
		rezulto += String(repeating: "=", count: titolo.count) + "\n"
		rezulto += titolo + "\n"
		rezulto += String(repeating: "=", count: titolo.count) + "\n"
		rezulto += "\n"
		for bloko in blokoj {
			rezulto += bloko.description + "\n"
		}
		
		return rezulto
	}
}
