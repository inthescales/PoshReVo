import ReVoModelojOSX

/// Fabriko fabrikanta vortojn.
struct VortoFabriko {
	var titolo: String?
	var teksto: String?
	var marko: String?
	var ofc: String?
	
	func fabriki() -> Vorto? {
		if let titolo = titolo,
		   let teksto = teksto {
			return Vorto(
				titolo: titolo,
				teksto: teksto,
				marko: marko,
				ofc: ofc
			)
		}
		
		return nil
	}
}
