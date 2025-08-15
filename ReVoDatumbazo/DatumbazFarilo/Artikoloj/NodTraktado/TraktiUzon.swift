extension ArboAnalizilo {
	static func trakti(uzon uzo: ArtikolNodo, tipo: String?, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: uzo, stato: stato)
		
		switch tipo {
		case "fak":
			// Ne aldoni fakvorton pro <uzo> ene de ekzemplo
			// Ekz. <uzo tip="MIT"> en derivaĵo 'ido', kiu ne aperu en faklisto
			let chuFariFakvorton: Bool
			switch stato.cheno.last {
			case .ekz:
				chuFariFakvorton = false
			default:
				chuFariFakvorton = true
			}
			
			// Krei fakvortojn
			if chuFariFakvorton,
			   let artikolIndekso = stato.artikolIndekso,
			   let marko = stato.marko {
				// NOTO: la reteja fakindekso inkluzivas nur la ĉefan formon
				// de derivaĵo, ne variaĵojn. Ekz. vd. 'apolon/o', el kiu 'Apolono'
				// aperas en la mitologia indekso, sed ne 'Apolo'
				for formo in stato.derivajhFormoj {
					let fakVorto = FakVorto(
						teksto: formo,
						indekso: artikolIndekso,
						marko: marko,
						senco: stato.nunaSenco
					)
					stato.aldoni(fakVorton: fakVorto, fako: teksto)
				}
			}
			
			let netaTeksto = Fako.netaKodo(por: teksto)
			return "[\(netaTeksto)] "
		case "klr":
			// Klarigo kutime havas parentezojn en sia fila teksto
			
			switch stato.cheno.last {
			case .drv, .subdrv, .snc, .subsnc:
				// Kiam klarigo-uzo aperas rekte en difino, necesas sekva spaco.
				// vd. 'najbara'
				return teksto + " "
			default:
				return teksto
			}
		case "stl":
			let stilTeksto = stato.stiloj[teksto] ?? teksto
			return "(\(stilTeksto)) "
		case nil:
			// vd. 'hurli'
			return teksto + " "
		default:
			assert(false, "Neatendita stilo")
			return ""
		}
	}
}
