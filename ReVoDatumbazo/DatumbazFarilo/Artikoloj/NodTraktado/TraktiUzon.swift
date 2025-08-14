extension ArboAnalizilo {
	static func trakti(uzon uzo: ArtikolNodo, tipo: String?, stato: Stato) -> String {
		let teksto = akumuliTekstojn(de: uzo, stato: stato)
		
		let apartigilo: String
		switch stato.cheno.last {
		case .dif, .ekz, .rim, .snc, .subsnc:
			apartigilo = " "
		default:
			// Mi volis ke kelkkaze uzojn en derivaĵo kaj sekva teksto en difino aperu
			// en unusama linio. Tamen, la retejo apartigas ilin en malsamajn liniojn,
			// kaj aperas kelkajn strangaĵojn se ni ne faras same ĉi tie.
			apartigilo = "\n"
		}
		
		switch tipo {
		case "fak":
			// Krei fakvortojn
			if let artikolIndekso = stato.artikolIndekso,
			   let marko = stato.marko {
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
			return "[\(netaTeksto)]" + apartigilo
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
			return "(\(stilTeksto))" + apartigilo
		case nil:
			// vd. 'hurli'
			return teksto + apartigilo
		default:
			assert(false, "Neatendita stilo")
			return ""
		}
	}
}
