extension BibliografioArboAnalizilo {
	static func trakti(bibliografion bibliografio: BibliografioNodo) -> [Verko] {
		var verkoj: [Verko] = []
		
		traktiFilojn(de: bibliografio) { filo in
			switch filo.tipo {
			case .vrk(let mll, _):
				let novaVerko = trakti(verkon: filo, mll: mll)
				verkoj.append(novaVerko)
			case .teksto:
				break
			default:
				assert(false, "neatendita filo")
			}
		}
		
		return verkoj
	}
}
