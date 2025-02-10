extension ArboAnalizilo {
	static func trakti(vortaron vortaro: ArtikolNodo, stato: TraktadoStato) {
		traktiFilojn(de: vortaro, stato: stato) { filo in
			switch filo.tipo {
			case .art(let mrk):
				trakti(artikolon: filo, marko: mrk, stato: stato)
			case .teksto:
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
	}
}
