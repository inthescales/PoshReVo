/// Fabriko fabrikanta subartikolojn.
struct SubartikoloFabriko {
	var teksto = ""
	var vortoj: [Vorto] = []
	
	func fabriki() -> Subartikolo? {
		return Subartikolo(
			teksto: teksto,
			vortoj: vortoj
		)
	}
}
