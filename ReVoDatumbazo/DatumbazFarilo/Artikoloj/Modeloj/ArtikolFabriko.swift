/// Fabriko fabrikanta artikolojn
struct ArtikolFabriko {
	var titolo: String?
	var radiko: String?
	var indekso: String?
	var ofc: String?
	var blokoj: [ArtikolBloko] = []
	
	func fabriki() -> Artikolo? {		
		if let titolo = titolo,
		   let radiko = radiko,
		   let indekso = indekso {
			return Artikolo(
				titolo: titolo,
				radiko: radiko,
				indekso: indekso,
				ofc: ofc,
				blokoj: blokoj
			)
		} else {
			assert(false, "Eraro okazis en artikol-legado")
			return nil
		}
	}
}
