extension ArboAnalizilo {
	static func traktiTildon(stato: Stato, litero: String?, variajho: String?) -> String {
		var teksto = ""
		
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
			teksto = TekstAtributo.volvi(teksto, per: .grasa)
		}
		
		return teksto
	}
}
