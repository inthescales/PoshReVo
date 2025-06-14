enum ArtikolAnalizilo {
	/// Rezulto de legado kaj traktado de artikolo
	struct Rezulto {
		var artikolo: Artikolo
		var serchTradukoj: [String: [SerchTraduko]]
		var serchVortoj: [SerchVorto]
		var fakVortoj: [String: [FakVorto]]
		var ofcVortoj: [Oficialeco: [OfcVorto]]
		var markSencoj: [String: Int]
		
		init(
			artikolo: Artikolo,
			serchTradukoj: [String: [SerchTraduko]],
			serchVortoj: [SerchVorto],
			fakVortoj: [String: [FakVorto]],
			ofcVortoj: [Oficialeco: [OfcVorto]],
			markSencoj: [String: Int]
		) {
			self.artikolo = artikolo
			self.serchTradukoj = serchTradukoj
			self.serchVortoj = serchVortoj
			self.fakVortoj = fakVortoj
			self.ofcVortoj = ofcVortoj
			self.markSencoj = markSencoj
		}
	}
	
	/// Legas  artikolon el indiko kaj liveras artikol-modelon kaj serĉ-tradukojn
	static func legi(
		el indikilo: String,
		grundo: Grundo,
		postTrakti: Bool = false
	) -> Rezulto {
		legi(
			el: indikilo,
			lingvoDict: grundo.lingvoDict,
			stiloDict: grundo.stiloDict,
			signoj: grundo.signoj,
			mallongigoj: grundo.mallongigojVerkaj,
			urloj: grundo.urloj,
			postTrakti: postTrakti
		)
	}
	/// Legas  artikolon el indiko kaj liveras artikol-modelon kaj serĉ-tradukojn
	static func legi(
		el indiko: String,
		lingvoDict: [String: Lingvo],
		stiloDict: [String: String],
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String],
		postTrakti: Bool = false
	) -> Rezulto {
		guard let arbo = ArtikolKonvertilo.konverti(
			el: indiko,
			signoj: signoj,
			mallongigoj: mallongigoj,
			urloj: urloj
		) else {
			assert(false, "Malsukcesis konverti artikolon '\(indiko)'")
		}
		
		let dosierNomo = String(indiko.split(separator: "/").last!)
		let indekso = dosierNomo.prefikso(ghis: dosierNomo.count - 4)
		
		guard let rezulto = ArboAnalizilo.analizi(
			arbon: arbo,
			indekso: indekso,
			lingvoj: lingvoDict,
			stiloj: stiloDict
		) else {
			assert(false, "Malsukcesis analizi artikolon '\(indiko)'")
		}
		
		// Ni ĝenerale ne posttraktu po-artikole, ĉar posttraktado bezonas aron da markSencoj.
		// Tamen, ĉi tio estas utila en testado.
		let artikolo: Artikolo
		if postTrakti {
			artikolo = Posttraktado.postTrakti(
				artikolon: rezulto.artikolo,
				markSencoj: rezulto.markSencoj
			)
		} else {
			artikolo = rezulto.artikolo
		}
		
		return Rezulto(
			artikolo: artikolo,
			serchTradukoj: rezulto.serchTradukoj,
			serchVortoj: rezulto.serchVortoj,
			fakVortoj: rezulto.fakVortoj,
			ofcVortoj: rezulto.ofcVortoj,
			markSencoj: rezulto.markSencoj
		)
	}
}
