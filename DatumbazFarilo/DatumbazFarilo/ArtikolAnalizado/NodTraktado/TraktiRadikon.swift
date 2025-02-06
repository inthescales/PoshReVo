extension ArboAnalizilo {
	static func trakti(radikon radiko: ArtikolNodo, variajho: String?, stato: TraktadoStato) -> String {
		let teksto = traktiFilojn(de: radiko, stato: stato)
		
		if variajho == nil {
			stato.artikolFabriko.radiko = teksto
		} else if let variajho = variajho {
			stato.artikolRadikVariajhoj[variajho] = teksto
		}
		
		return teksto
	}
}
