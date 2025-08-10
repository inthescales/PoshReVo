extension ArboAnalizilo {
	static func trakti(
		subartikolon subartikolo: ArtikolNodo,
		numero: Int,
		stato: Stato
	) -> [ArtikolBloko] {
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
				akumulilo.aldoni(tekston: trakti(sencon: filo, marko: mrk, stato: stato))
			case .teksto:
				break
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .uzo(let tip):
				akumulilo.aldoni(tekston:  trakti(uzon: filo, tipo: tip, stato: stato))
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return akumulilo.fariBlokojn()
	}
}
