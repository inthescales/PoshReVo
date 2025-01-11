import Foundation
import ReVoModelojOSX

struct SubartikoloFabriko {
	var teksto = ""
	var vortoj: [Vorto] = []
	
	func fabriki() -> Subartikolo? {
		if !vortoj.isEmpty {
			return Subartikolo(
				teksto: teksto,
				vortoj: vortoj
			)
		}
		
		return nil
	}
}

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

struct ArtikolFabriko {
	var titolo: String?
	var radiko: String?
	var indekso: String?
	var ofc: String?
	var subartikoloj: [Subartikolo] = []
	var tradukoj: [Traduko]?
	
	func fabriki() -> Artikolo? {
		if let titolo = titolo,
		   let radiko = radiko,
		   let indekso = indekso,
		   !subartikoloj.isEmpty {
			return Artikolo(
				titolo: titolo,
				radiko: radiko,
				indekso: indekso,
				ofc: ofc,
				subartikoloj: subartikoloj,
				tradukoj: tradukoj ?? []
			)
		} else {
			assert(false, "Ni vidu ĉu ĉi tio okazos")
		}
	}
}

class Stato {
	var artikolFabriko = ArtikolFabriko()
	var subartikoloFabriko: SubartikoloFabriko?
	var vortoFabriko: VortoFabriko?
	
	var bufro: String = ""
	var cheno: [NodTipo] = []
	
	func nuligiBufron() {
		bufro = ""
	}
	
	func konsumiBufron() {
		if vortoFabriko != nil {
			if vortoFabriko?.teksto == nil {
				vortoFabriko?.teksto = ""
			}
			vortoFabriko?.teksto? += bufro.kunpremi(" ")
		} else if subartikoloFabriko != nil {
			subartikoloFabriko?.teksto += bufro.kunpremi(" ")
		}
		
		nuligiBufron()
	}
	
	func spaciBufron() {
		let krampoj = ["(", "{", "[", "<"]
		let spacoj = [" "]
		if !bufro.isEmpty
			&& !krampoj.contains(String(bufro.last!))
			&& !spacoj.contains(String(bufro.last!)) {
			bufro += " "
		}
	}
}
