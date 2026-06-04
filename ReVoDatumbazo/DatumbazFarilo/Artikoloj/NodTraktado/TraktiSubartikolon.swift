extension ArboAnalizilo {
	static func trakti(
		subartikolon subartikolo: ArtikolNodo,
		numero: Int,
		stato: Stato
	) -> [ArtikolBloko] {
		let sencKvanto = subartikolo.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
		
		let akumulilo = BlokAkumulilo()
		akumulilo.aldoni(blokojn: [
			.dividila(teksto: ArtikolTeksto.romajCiferoj(por: numero + 1) + ".")
		])
		
		traktiFilojn(de: subartikolo, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .dif:
				akumulilo.aldoni(tekston: trakti(difinon: filo, stato: stato))
			case .drv(let mrk):
				akumulilo.aldoni(blokojn: trakti(derivajhon: filo, marko: mrk, stato: stato))
			case .gra:
				akumulilo.aldoni(tekston: trakti(gramatikon: filo, stato: stato))
			case .rim(let num):
				akumulilo.aldoni(tekston: trakti(rimarkon: filo, numero: num, stato: stato))
			case .snc(let mrk):
				let antauSencaSpaco = antauSencaSpaco(
					unuaSenco: stato.lastaSenco == nil,
					montrosEtikedon: sencKvanto > 1,
					freshaLinio: akumulilo.freshaLinio(),
					stato: stato
				) ?? ""
				akumulilo.aldoni(tekston: antauSencaSpaco)
				
				let filTeksto = trakti(
					sencon: filo,
					marko: mrk,
					montriEtikedon: sencKvanto > 1,
					freshaLinio: akumulilo.freshaLinio(),
					stato: stato
				)
				akumulilo.aldoni(tekston: filTeksto)
			case .teksto:
				break
			case .trd, .trdgrp:
				/*
					Ĉi tiuj estas senefikaj ĉar la apo nuntempe ne montras tradukojn ene de
					subartikolo: la traduko-traktado kiel ĝi nun staras antaŭsupozas ke tradukoj apartenas
					nur al derivaĵoj, kaj mi ne facile trovas taŭgan manieron prezenti ilin.
				 
					Cetere, ili estas tre malvaste uzataj en la ReVo-retejo, kaj post mallonga diskuto
					Volframo kaj mi konsentis ke la plejmulto estu movitaj, kaj ke ĉi tie eblas nur ignori
					la restantajn. Tamen, ili restas permesataj de la dokumentstrukturo.
				 */
				break
			case .uzo(let tip):
				akumulilo.aldoni(tekston:  trakti(uzon: filo, tipo: tip, stato: stato))
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		stato.lastaSenco = nil
		
		return akumulilo.fariBlokojn()
	}
}
