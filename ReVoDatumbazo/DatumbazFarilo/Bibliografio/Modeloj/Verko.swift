/// Verko en la bibliografio
struct Verko {
	let mallongigo: String
	let titolo: String
	let titolAldono: String?
	let autoro: String?
	let tradukisto: String?
	let eldono: Eldono?
	let url: String?
	
	func priskribi() -> String {
		var teksto = ""
		
		if let autoro {
			teksto += autoro + "\\n"
		} else if let eldono,
				  let nomo = eldono.nomo {
			teksto += nomo + "\\n"
		}
		
		if let tradukisto {
			teksto += "trd. " + tradukisto + "\\n"
		}
		
		teksto += TekstAtributo.volvi(titolo, per: .kursiva)
		
		if let eldono,
		   let eldonDato = eldono.dato {
			teksto += "\\n" + eldonDato
		}
		
		return teksto.tondi().kunpremi()
	}
}

// MARK: - Equatable

extension Verko: Equatable {
	public static func == (lhs: Verko, rhs: Verko) -> Bool {
		return lhs.mallongigo == rhs.mallongigo
	}
}
	
// MARK: - Comparable

extension Verko: Comparable {
	public static func < (lhs: Verko, rhs: Verko) -> Bool {
		return lhs.mallongigo < rhs.mallongigo
	}
}
