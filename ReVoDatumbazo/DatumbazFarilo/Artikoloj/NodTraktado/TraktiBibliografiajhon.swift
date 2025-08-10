extension ArboAnalizilo {
	static func trakti(bibliografiajhon bib: ArtikolNodo, stato: Stato) -> String {
		return akumuliTekstojn(de: bib, stato: stato).tondi()
	}
}
