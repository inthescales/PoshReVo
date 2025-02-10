extension ArboAnalizilo {
	static func trakti(tradukGrupon tradukGrupo: ArtikolNodo, lingvo: String, stato: TraktadoStato) {
		traktiFilojn(de: tradukGrupo, stato: stato) { filo in
			switch filo.tipo {
			case .trd:
				trakti(tradukon: filo, lingvo: lingvo, stato: stato)
			case .teksto:
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
	}
}
