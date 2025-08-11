enum BibliografioAnalizilo {
	/// Legas  bibliografion el indiko kaj liveras verko-modelojn
	static func legi(
		el indikilo: String,
		grundo: Grundo
	) -> [Verko] {
		legi(
			el: indikilo,
			signoj: grundo.signoj
		)
	}
	/// Legas  la bibliografion el indiko kaj liveras bibliografio-modelon kaj serĉ-tradukojn
	static func legi(
		el indiko: String,
		signoj: [String: String]
	) -> [Verko] {
		guard let arbo = BibliografioKonvertilo.konverti(
			el: indiko,
			signoj: signoj
		) else {
			assert(false, "Malsukcesis konverti bibliografion")
		}
		
		return BibliografioArboAnalizilo.analizi(arbon: arbo)
	}
}
