extension ArboAnalizilo {
	static func trakti(derivajhon derivajho: ArtikolNodo, marko: String, stato: Stato) {
		var kapTeksto = ""
		var oficialeco: String?
		
		var teksto = ""
		let sencKvanto = derivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
		
		traktiFilojn(de: derivajho, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .bld:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
				if sencKvanto > 0 && stato.lastaSenco != sencKvanto {
					teksto += "\n"
				}
			case .fnt:
				switch stato.sibStako.last {
				case .uzo:
					// XXX: Uzoj devas lasi spacon tekst-fine.
					break
				default:
					teksto = teksto.tondi()
				}
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .kap:
				let kapRezulto = trakti(kapon: filo, stato: stato)
				kapTeksto = kapRezulto.teksto
				oficialeco = kapRezulto.oficialeco
				
				if let indekso = stato.artikolIndekso,
				   let marko = stato.marko {
					for variajho in kapRezulto.formoj {
						let serchajho = SerchVorto(
							teksto: variajho,
							indekso: indekso,
							marko: marko
						)
						stato.aldoni(serchVorton: serchajho)
					}
				}
			case .mlg:
				// TODO: Trakti kapajn mallongigojn
				// Endos aldoni ion al vorto-modelo
				break
			case .lstref(let lst):
				teksto += trakti(listReferencon: filo, listo: lst, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .rim:
				teksto += trakti(rimarkon: filo, stato: stato)
			case .snc(let mrk):
				let filTeksto = trakti(sencon: filo, marko: mrk, stato: stato)
				
				if sencKvanto > 1,
				   let sencNombro = stato.lastaSenco {
					if sencNombro > 1 {
						teksto += "\n\n"
					}
					teksto += String(sencNombro) + ". "
				}
				
				teksto += filTeksto
			case .subdrv:
				let filTeksto = trakti(subderivajhon: filo, stato: stato)
				
				if let subdrvNumero = stato.lastaSubderivajho {
					if subdrvNumero > 1 {
						teksto += "\n\n"
					}
					teksto += ArtikolTeksto.subdrvLitero(por: subdrvNumero)! + ". "
				}
				
				teksto += filTeksto
			case .tld(let lit, let vari):
				teksto += traktiTildon(stato: stato, litero: lit, variajho: vari)
			case .teksto:
				break
			case .tezrad:
				break
			case .trd(let lng):
				trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .url(let ref):
				teksto += "\n\n" + trakti(URLon: filo, referenco: ref, stato: stato)
			case .uzo(let tip):
				teksto += trakti(uzon: filo, tipo: tip, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		let titoloBloko: ArtikolBloko = .derivajhTitola(teksto: kapTeksto, ofc: oficialeco, marko: marko)
		
		// TODO: Dividi tekstblokojn
		let tekstoBloko: ArtikolBloko = .teksta(teksto: teksto.kunpremi().tondi())
						
		var tradukoj: [Traduko] = []
		for (lingvoKodo, trdoj) in stato.derivajhTradukoj {
			let teksto = ArtikolTeksto.tradukTeksto(por: trdoj)
			let trd = Traduko(
				lingvo: stato.lingvoj[lingvoKodo]!,
				teksto: teksto
			)
			tradukoj.append(trd)
		}
		let tradukoBloko: ArtikolBloko = .traduka(tradukoj: tradukoj)
		
		stato.artikolFabriko.blokoj += [titoloBloko, tekstoBloko, tradukoBloko]
		
		// Eliras derivaĵon
		stato.derivajhNomo = nil
		stato.derivajhTildo = nil
		stato.derivajhTradukoj = [:]
		stato.lastaSenco = nil
	}
}
