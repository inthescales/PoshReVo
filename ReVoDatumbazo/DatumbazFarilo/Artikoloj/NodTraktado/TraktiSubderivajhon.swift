extension ArboAnalizilo {
	// Notu ke ĉiuj subderivaĵoj en derivaĵo prezentas unusolan serion de sencnumeroj
	static func trakti(
		subderivajhon subderivajho: ArtikolNodo,
		stato: Stato
	) -> String {
		if stato.lastaSubderivajho == nil {
			stato.lastaSubderivajho = 0
		}
		
		stato.lastaSubderivajho? += 1
		stato.nunaSubderivajho = stato.lastaSubderivajho
		
		let sencKvanto = subderivajho.filoj.map { if case .snc = $0.tipo { return 1 } else { return 0 }}.reduce(0, +)
		let numeriSencojn = sencKvanto > 1 || (stato.lastaSenco ?? 0) > 0
		
		var teksto = ""
		traktiFilojn(de: subderivajho, stato: stato) { filo in
			switch filo.tipo {
			case .adm:
				break
			case .dif:
				teksto += trakti(difinon: filo, stato: stato)
			case .gra:
				teksto += trakti(gramatikon: filo, stato: stato)
			case .ref(let tip, let cel):
				teksto += trakti(referencon: filo, tipo: tip, celo: cel, stato: stato)
			case .refgrp(let tip):
				teksto += trakti(referencGrupon: filo, tipo: tip, stato: stato)
			case .rim(let num):
				teksto += trakti(rimarkon: filo, numero: num, stato: stato)
			case .snc(let mrk):
				let filTeksto = trakti(
					sencon: filo,
					marko: mrk,
					montriEtikedon: numeriSencojn,
					freshaLinio: teksto.last == "\n",
					stato: stato
				)
				
				teksto += filTeksto
			case .teksto:
				break
			case .trd(let lng):
				_ = trakti(tradukon: filo, lingvo: lng!, stato: stato)
			case .trdgrp(let lng):
				trakti(tradukGrupon: filo, lingvo: lng, stato: stato)
			default:
				assert(false, "Neatendita filo")
			}
		}
		
		// Eliras sencon
		stato.nunaSubderivajho = nil
		
		return teksto
	}
}
