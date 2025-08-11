enum BibliografioArboAnalizilo {
	static func analizi(
		arbon arbo: BibliografioNodo
	) -> [Verko] {
		return trakti(arbon: arbo)
	}
	
	static func trakti(arbon arbo: BibliografioNodo) -> [Verko] {
		assert(arbo.filoj.count == 1, "Tro da filoj en bibliografia arboradiko")
		let filo = arbo.filoj.first!
		switch filo.tipo {
		case .bibliografio:
			return trakti(bibliografion: filo)
		default:
			assert(false, "Neatendita filo")
		}
	}
	
	// MARK: - Nodspecoj
	
	/// Akumulas tekston el teksto-nodoj, kaj alispecaj nodoj kiuj enhavas nur tekstojn
	static func akumuliTekstojn(de nodo: BibliografioNodo) -> String {
		var teksto = ""
		traktiFilojn(de: nodo) { filo in
			switch filo.tipo {
			case .a, .n:
				teksto += akumuliTekstojn(de: filo)
			case .teksto(let filTeksto):
				teksto += filTeksto.prepari()
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return teksto
	}
	
	static func traktiFilojn(de nodo: BibliografioNodo, farotajh: (BibliografioNodo) -> Void) {
		for filo in nodo.filoj {
			farotajh(filo)
		}
	}
}
