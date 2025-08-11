extension BibliografioArboAnalizilo {
	static func trakti(verkon verko: BibliografioNodo, mll: String) -> Verko {
		var titolo: String?
		var aldono: String?
		var autoro: String?
		var tradukisto: String?
		var eldono: Eldono?
		var url: String?
		
		traktiFilojn(de: verko) { filo in
			switch filo.tipo {
			case .ald:
				aldono = akumuliTekstojn(de: filo)
			case .aut:
				autoro = akumuliTekstojn(de: filo)
			case .eld:
				eldono = trakti(eldonon: filo)
			case .tit:
				titolo = akumuliTekstojn(de: filo)
			case .trd:
				tradukisto = akumuliTekstojn(de: filo)
			case .url:
				url = akumuliTekstojn(de: filo)
			case .teksto:
				break
			default:
				assert(false, "neatendita filo")
			}
		}
		
		guard let titolo else {
			assert(false, "mankas al verko informoj")
		}
		
		return Verko(
			mallongigo: mll,
			titolo: titolo,
			titolAldono: aldono,
			autoro: autoro,
			tradukisto: tradukisto,
			eldono: eldono,
			url: url
		)
	}
}
