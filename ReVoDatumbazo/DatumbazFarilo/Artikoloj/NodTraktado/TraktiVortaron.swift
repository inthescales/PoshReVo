extension ArboAnalizilo {
	static func trakti(vortaron vortaro: ArtikolNodo, stato: Stato) -> [ArtikolBloko] {
		let akumulilo = BlokAkumulilo()
		
		traktiFilojn(de: vortaro, stato: stato) { filo in
			switch filo.tipo {
			case .art(let mrk):
				akumulilo.aldoni(blokojn: trakti(artikolon: filo, marko: mrk, stato: stato))
			case .teksto:
				break
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		return akumulilo.fariBlokojn()
	}
}
