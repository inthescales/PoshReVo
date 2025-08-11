extension BibliografioArboAnalizilo {
	static func trakti(eldonon eldono: BibliografioNodo) -> Eldono {
		var nomo: String?
		var loko: String?
		var numero: String?
		var dato: String?
		var isbn: String?
		
		traktiFilojn(de: eldono) { filo in
			switch filo.tipo {
			case .nom:
				nomo = akumuliTekstojn(de: filo)
			case .dat:
				dato = akumuliTekstojn(de: filo)
			case .isbn:
				isbn = akumuliTekstojn(de: filo)
			case .lok:
				loko = akumuliTekstojn(de: filo)
			case .nro:
				numero = akumuliTekstojn(de: filo)
			case .teksto:
				break
			default:
				assert(false, "neatendita filo")
			}
		}
		
		return Eldono(nomo: nomo, loko: loko, numero: numero, dato: dato, isbn: isbn)
	}
}
