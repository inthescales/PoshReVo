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
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				// vd. -ig
				break
			case .drv(let mrk):
				akumulilo.aldoni(blokojn: trakti(derivajhon: filo, marko: mrk, stato: stato))
			case .fnt:
				// Se estontece artikolojn rekte enhavos tekstojn, tondu ĉi tie
				break
			case .kap:
				_ = trakti(kapon: filo, stato: stato)
			case .ref:
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				break
			case .refgrp:
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				// vd. apriora
				break
			case .rim:
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				// vd. premi
				break
			case .subart:
				akumulilo.aldoni(blokojn: trakti(subartikolon: filo, numero: subartikoloNumero, stato: stato))
				subartikoloNumero += 1
			case .teksto:
				break
			case .trd(let lng):
				trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			case .url:
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				// vd. 'dateno'
				break
			case .uzo:
				// TODO: Nuna apo-interfaco ne povas montri tekstajn materialojn artikol-fine. Aldonu tion.
				// vd. 'asembli'
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return akumulilo.fariBlokojn()
	}
}
