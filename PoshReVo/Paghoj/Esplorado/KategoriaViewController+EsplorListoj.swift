import UIKit

import ReVoDatumbazo

/// Ĉi-aldono enhavas kodon por krei esplorlistojn
extension KategoriaViewController {
	// MARK: - Fakoj
	
	/// Krei paĝon montranta liston da fakoj, per kiu uzanto povu navigacii al fakoj kaj iliaj vortoj
	static func fakListo(
		vortaro: VortaroDatumbazo,
		elektisArtikolon: @escaping (Destino) -> Void,
	) -> KategoriaViewController {
		let listeroj = vortaro.chiujFakoj.map { fako in
			KategoriaViewController.Listero(
				teksto: fako.nomo,
				celPagho: {
					Self.fakVortoj(fako: fako, vortaro: vortaro, elektisArtikolon: elektisArtikolon)
				}
			)
		}
		
		return KategoriaViewController(titolo: Tekstoj.fakoj, listeroj: listeroj)
	}
	
	/// Krei paĝon montranta liston da vortoj en fako, per kiu uzanto povu navigacii al individuaj artikoloj
	static func fakVortoj(
		fako: Fako,
		vortaro: VortaroDatumbazo,
		elektisArtikolon: @escaping (Destino) -> Void
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero>(titolo: fako.nomo) { listero in
			elektisArtikolon(listero.destino)
		}
		
		let destinoj = vortaro.fakVortoj(fako: fako.kodo)
		vc.montri(listerojn: destinoj.map {
			Esplorlistero(
				teksto: $0.teksto,
				destino: $0
			)
		})
		
		return vc
	}
	
	// MARK: - Oficialecoj
	
	/// Krei paĝon montranta liston da oficialecoj, per kiu uzanto povu navigacii al oficialecoj kaj iliaj vortoj
	static func oficialecoListo(
		vortaro: VortaroDatumbazo,
		elektisArtikolon: @escaping (Destino) -> Void
	) -> KategoriaViewController {
		let oficialigoEroj = vortaro.chiujOficialigoj.map { ofc in
			KategoriaViewController.Listero(
				teksto: ofc.nomo,
				celPagho: {
					Self.oficialecoVortoj(ofc: ofc, vortaro: vortaro, elektisArtikolon: elektisArtikolon)
				}
			)
		}
		
		var sekcioj: [KategoriaViewController.Sekcio] = [
			.init(
				titolo: Tekstoj.oficialigoj,
				eroj: oficialigoEroj
			)
		]
		
		if let neoficialaj = vortaro.neoficialaj {
			let neoficialajEro = KategoriaViewController.Listero(
				teksto: neoficialaj.nomo,
				celPagho: {
					Self.oficialecoVortoj(
						ofc: neoficialaj,
						vortaro: vortaro,
						elektisArtikolon: elektisArtikolon
					)
				}
			)
			let neoficialajSekcio = KategoriaViewController.Sekcio(
				titolo: nil,
				eroj: [neoficialajEro]
			)
			sekcioj.append(neoficialajSekcio)
		}

		return KategoriaViewController(
			titolo: Tekstoj.oficialecoj,
			sekcioj: sekcioj
		)
	}
	
	/// Krei paĝon montranta liston da vortoj en oficialeco, per kiu uzanto povu navigacii al individuaj artikoloj
	static func oficialecoVortoj(
		ofc: Oficialeco,
		vortaro: VortaroDatumbazo,
		elektisArtikolon: @escaping (Destino) -> Void
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero>(titolo: ofc.nomo) { listero in
			elektisArtikolon(listero.destino)
		}
		
		let destinoj = vortaro.ofcVortoj(oficialeco: ofc.kodo)
		vc.montri(listerojn: destinoj.map {
			Esplorlistero(
				teksto: $0.teksto,
				destino: $0
			)
		})
		
		return vc
	}
}
