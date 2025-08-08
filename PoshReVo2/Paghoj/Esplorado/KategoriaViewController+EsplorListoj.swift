import UIKit

import ReVoDatumbazo

// Jen aldono enhavanta kodon por krei esplorlistojn

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
		let listeroj = vortaro.chiujOficialecoj.map { ofc in
			KategoriaViewController.Listero(
				teksto: ofc.nomo,
				celPagho: {
					Self.oficialecoVortoj(ofc: ofc, vortaro: vortaro, elektisArtikolon: elektisArtikolon)
				}
			)
		}
		return KategoriaViewController(titolo: Tekstoj.oficialecoj, listeroj: listeroj)
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
