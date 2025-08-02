extension ArboAnalizilo {
	static func trakti(
		tradukGrupon tradukGrupo: ArtikolNodo,
		lingvo: String,
		transpasIndekso: IndeksRezulto? = nil,
		stato: Stato
	) {
		traktiFilojn(de: tradukGrupo, stato: stato) { filo in
			switch filo.tipo {
			case .trd:
				_ = trakti(tradukon: filo, lingvo: lingvo, transpasIndekso: transpasIndekso, stato: stato)
			case .teksto:
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
	}
}
