public final class Artikolo: Codable {
	/// Titolo de la artikolo – kutime la radiko kaj ĝia baza finaĵo
	public let titolo: String
	
	/// La radiko reprezentata de la artikolo, sen finaĵo
	public let radiko: String
	
	/// Indekso serĉebla kiu indikas ĉi-artikolon
	public let indekso: String
	
	/// Oficialeco de la radiko. Se ekzistas pluraj variaĵoj, la plej frua inter ili
	public let ofc: String?
	
	public let blokoj: [ArtikolBloko]
	
	public init(
		titolo: String,
		radiko: String,
		indekso: String,
		ofc: String?,
		blokoj: [ArtikolBloko]
	) {
		self.titolo = titolo
		self.radiko = radiko
		self.indekso = indekso
		self.ofc = ofc
		self.blokoj = blokoj
	}
}
