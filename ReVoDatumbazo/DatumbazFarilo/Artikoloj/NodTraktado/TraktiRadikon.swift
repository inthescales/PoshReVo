extension ArboAnalizilo {
	/// Trakti bazan radikon.
	static func trakti(radikon radiko: ArtikolNodo, variajho: String?, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: radiko, stato: stato)
		stato.artikolFabriko.radiko = teksto
		return teksto
	}
	
	/// Trakti radikon kiu aperas ene de <var>. Eble havas etikedon (ekz. <rad var="v">), eble ne.
	static func traktiVariajhan(radikon radiko: ArtikolNodo, etikedo: String?, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: radiko, stato: stato)
		
		if let etikedo {
			stato.artikolRadikVariajhoj[etikedo] = teksto
		}
		
		return teksto
	}
}
