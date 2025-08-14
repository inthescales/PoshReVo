extension ArboAnalizilo {
	static func trakti(variajhon variajho: ArtikolNodo, stato: Stato) -> (nomo: String, tildo: String) {
		var rezulto: (nomo: String, tildo: String)? = nil
		
		traktiFilojn(de: variajho, stato: stato) { filo in
			switch filo.tipo {
			case .kap:
				let kapRezulto = trakti(kapon: filo, stato: stato)
				rezulto = (kapRezulto.teksto, kapRezulto.tildTeksto)
			case .teksto:
				break
			case .uzo:
				// TODO: Trakti uzo en variajho
				// Vidu artikolon 'kramf/o', kie titolo enhavas "kramf/o, krampf/i (arkaism)
				// Endos aldoni ion al vorto-modelo
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return rezulto!
	}
}
