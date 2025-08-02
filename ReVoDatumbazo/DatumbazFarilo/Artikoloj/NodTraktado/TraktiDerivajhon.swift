extension ArboAnalizilo {
	static func trakti(
		derivajhon derivajho: ArtikolNodo,
		marko: String,
		stato: Stato
	) -> [ArtikolBloko] {
		var kapTeksto = ""
		var oficialeco: String?
		let sencKvanto = derivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
		
		let akumulilo = BlokAkumulilo()
		
		traktiFilojn(de: derivajho, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .bld:
				break
			case .dif:
				akumulilo.aldoni(tekston: trakti(difinon: filo, stato: stato))
				if sencKvanto > 0 && stato.lastaSenco != sencKvanto {
					akumulilo.aldoni(tekston: "\n")
				}
			case .fnt:
				traktiFonton(akumulilo: akumulilo, stato: stato)
			case .gra:
				akumulilo.aldoni(tekston: trakti(gramatikon: filo, stato: stato))
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
				// Vidu 'Om/o'
				break
			case .lstref(let lst):
				akumulilo.aldoni(tekston: trakti(listReferencon: filo, listo: lst, stato: stato))
			case .ref(let tip, let cel):
				akumulilo.aldoni(tekston: trakti(referencon: filo, tipo: tip, celo: cel, stato: stato))
			case .refgrp(let tip):
				akumulilo.aldoni(tekston: trakti(referencGrupon: filo, tipo: tip, stato: stato))
			case .rim:
				akumulilo.aldoni(tekston:  trakti(rimarkon: filo, stato: stato))
			case .snc(let mrk):
				let filTeksto = trakti(sencon: filo, marko: mrk, stato: stato)
				
				if sencKvanto > 1,
				   let sencNombro = stato.lastaSenco {
					if sencNombro > 1 {
						akumulilo.aldoni(tekston:  "\n\n")
					}
					let volvitaTeksto = TekstAtributo.volvi(String(sencNombro) + ". ", per: .sencNumero)
					akumulilo.aldoni(tekston: volvitaTeksto)
				}
				
				akumulilo.aldoni(tekston:  filTeksto)
			case .subdrv:
				let filTeksto = trakti(subderivajhon: filo, stato: stato)
				
				if let subdrvNumero = stato.lastaSubderivajho {
					if subdrvNumero > 1 {
						akumulilo.aldoni(tekston:  "\n\n")
					}
					let volvitaTeksto = TekstAtributo.volvi(ArtikolTeksto.subdrvLitero(por: subdrvNumero)! + ". ", per: .sencNumero)
					akumulilo.aldoni(tekston: volvitaTeksto)
				}
				
				akumulilo.aldoni(tekston: filTeksto)
			case .tld(let lit, let vari):
				akumulilo.aldoni(tekston: traktiTildon(stato: stato, litero: lit, variajho: vari))
			case .teksto:
				break
			case .tezrad:
				break
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .url(let ref):
				let novaTeksto = "\n\n" + trakti(URLon: filo, referenco: ref, stato: stato)
				akumulilo.aldoni(tekston: novaTeksto)
			case .uzo(let tip):
				akumulilo.aldoni(tekston: trakti(uzon: filo, tipo: tip, stato: stato))
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		var blokoj: [ArtikolBloko] = []
		
		blokoj.append(.derivajhTitola(teksto: kapTeksto, ofc: oficialeco, marko: marko))
		
		akumulilo.kunpremiTekston()
		akumulilo.tondiTekston()
		blokoj += akumulilo.fariBlokojn()
						
		var tradukoj: [Traduko] = []
		for (lingvoKodo, trdoj) in stato.derivajhTradukoj {
			let teksto = ArtikolTeksto.tradukTeksto(por: trdoj)
			let trd = Traduko(
				lingvo: stato.lingvoj[lingvoKodo]!,
				teksto: teksto
			)
			tradukoj.append(trd)
		}
		blokoj.append(.traduka(tradukoj: tradukoj))
		
		// Eliras derivaĵon
		stato.derivajhNomo = nil
		stato.derivajhTildo = nil
		stato.forigiDerivajhTradukojn()
		stato.lastaSenco = nil
		
		return blokoj
	}
}
