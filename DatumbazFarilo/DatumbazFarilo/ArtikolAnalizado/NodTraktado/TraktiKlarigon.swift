extension ArboAnalizilo {
	static func trakti(klarigon klarigo: ArtikolNodo, stato: TraktadoStato) -> String {
		var teksto = akumuliTekstojn(de: klarigo, stato: stato)
		
		// Liveri tekston, sen emfazoj (ekz. "Banderolo" en)
		teksto = teksto.replacingOccurrences(of: "<em>", with: "")
		teksto = teksto.replacingOccurrences(of: "</em>", with: "")
		
		return teksto
	}
}
