extension ArboAnalizilo {
	static func traktiTildon(stato: TraktadoStato, litero: String?, variajho: String?) -> String {
		var teksto = ""
		if case .ekz = stato.cheno.last {
			teksto += "<b>"
		}
		
		let radiko: String
		if variajho == nil,
		   let artikolRadiko = stato.artikolFabriko.radiko {
			radiko = artikolRadiko
		} else if let variajho = variajho,
				  let variajhRadiko = stato.artikolRadikVariajhoj[variajho] {
			radiko = variajhRadiko
		} else {
			assert(false, "Ne trovis taŭgan radikon por <tld/>")
			return ""
		}
		
		if let litero = litero {
			teksto += litero + radiko.sufikso(de: 1)
		} else {
			teksto += radiko
		}
		
		if case .ekz = stato.cheno.last {
			teksto += "</b>"
		}
		
		return teksto
	}
}
