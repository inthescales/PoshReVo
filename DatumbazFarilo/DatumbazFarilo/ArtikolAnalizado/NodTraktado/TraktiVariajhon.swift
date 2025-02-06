extension ArboAnalizilo {
	static func trakti(variajhon variajho: ArtikolNodo, stato: TraktadoStato) -> (nomo: String, tildo: String) {
		var rezulto: (nomo: String, tildo: String)? = nil
		traktiFilojn(de: variajho, stato: stato) { filo in
			switch filo.tipo {
			case .kap:
				rezulto = trakti(kapon: filo, stato: stato)
			case .teksto:
				break
			case .uzo:
				// TODO: Trakti uzo en variajho (vd. art-on 'kramf/o')
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return rezulto!
	}
}
