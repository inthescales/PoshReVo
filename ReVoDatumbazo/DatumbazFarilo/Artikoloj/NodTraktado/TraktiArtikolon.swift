extension ArboAnalizilo {
	static func trakti(
		artikolon artikolo: ArtikolNodo,
		marko: String?,
		stato: Stato
	) -> [ArtikolBloko] {
		var subartikoloNumero = 0
		
		let akumulilo = BlokAkumulilo()
		
		traktiFilojn(de: artikolo, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .bld:
				// vd. bugenvilo
				break
			case .dif:
				// vd. -ig
				akumulilo.aldoni(tekston: trakti(difinon: filo, stato: stato))
				break
			case .drv(let mrk):
				akumulilo.aldoni(blokojn: trakti(derivajhon: filo, marko: mrk, stato: stato))
			case .fnt:
				ignoriFonton(akumulilo: akumulilo, stato: stato)
			case .kap:
				_ = trakti(kapon: filo, stato: stato)
			case .ref(let tipo, let celo):
				// vd. don1 (Don/o)
				akumulilo.aldoni(tekston: trakti(referencon: filo, tipo: tipo, celo: celo, stato: stato))
			case .refgrp(let tipo):
				// vd. apriora
				akumulilo.aldoni(tekston: trakti(referencGrupon: filo, tipo: tipo, stato: stato))
			case .rim(let num):
				// vd. premi
				let filteksto = trakti(rimarkon: filo, numero: num, sekvasTekston: akumulilo.tenasTekston(), stato: stato)
				akumulilo.aldoni(tekston: filteksto)
			case .subart:
				akumulilo.aldoni(blokojn: trakti(subartikolon: filo, numero: subartikoloNumero, stato: stato))
				subartikoloNumero += 1
			case .teksto:
				break
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .url(let ref):
				// vd. 'dateno'
				akumulilo.aldoni(tekston: trakti(URLon: filo, referenco: ref, stato: stato))
			case .uzo(let tipo):
				// vd. 'asembli'
				akumulilo.aldoni(tekston: trakti(uzon: filo, tipo: tipo, stato: stato))
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return akumulilo.fariBlokojn()
	}
}
