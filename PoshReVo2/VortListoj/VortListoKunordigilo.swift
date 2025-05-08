import UIKit

import ReVoDatumbazo

final class VortListoKunordigilo {
	// MARK: Agordoj
	
	let prezentiArtikolon: (Artikolo, UINavigationController) -> ()
	
	let prezentiArtikolonElDestino: (Destino, UINavigationController) -> ()
	
	let datumbazo: VortaroDatumbazo
	
	let uzantDatumaro: UzantDatumaro
	
	//
	
	init(
		prezentiArtikolon: @escaping (Artikolo, UINavigationController) -> (),
		prezentiArtikolonElDestino: @escaping (Destino, UINavigationController) -> (),
		datumbazo: VortaroDatumbazo = .komuna,
		uzantDatumaro: UzantDatumaro = .komuna
	) {
		self.prezentiArtikolon = prezentiArtikolon
		self.prezentiArtikolonElDestino = prezentiArtikolonElDestino
		self.datumbazo = datumbazo
		self.uzantDatumaro = uzantDatumaro
	}
	
	func prezentiEsplorMenuon(prezentilo: UINavigationController) {
		let listeroj: [KategoriaViewController.Listero] = [
			.init(
				teksto: "Fakoj",
				celPagho: { [unowned self] in fariFakListon(prezentilo: prezentilo) }
			),
			.init(
				teksto: "Vortoj Laŭ Oficialeco",
				celPagho: { [unowned self] in fariOficialecoListon(prezentilo: prezentilo) }
			),
			. init(
				teksto: "Hazarda Artikolo",
				celPagho: { [unowned self] in fariHazardanArtikolon() }
			)
		]
		
		let vc = KategoriaViewController(listeroj: listeroj)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	// MARK: Fakoj
	
	func fariFakListon(prezentilo: UINavigationController) -> KategoriaViewController {
		let listeroj = datumbazo.chiujFakoj.map { fako in
			KategoriaViewController.Listero(
				teksto: fako.nomo,
				celPagho: { [unowned self] in
					fariFakVortliston(por: fako, prezentilo: prezentilo)
				}
			)
		}
		return KategoriaViewController(listeroj: listeroj)
	}
	
	func fariFakVortliston(
		por fako: Fako,
		prezentilo: UINavigationController
	) -> VortoListoViewController {
		let vc = VortoListoViewController { [weak self] listero in
			guard let self,
				  listero.destinoj.count == 1,
				  let celo = listero.destinoj.first else {
				return
			}
			
			prezentiArtikolonElDestino(celo, prezentilo)
		}
		
		let destinoj = datumbazo.fakVortoj(fako: fako.kodo)
		vc.montri(listerojn: destinoj.map {
			VortoListoViewController.Listero(
				teksto: $0.teksto,
				subteksto: nil,
				destinoj: [$0]
			)
		})
		
		return vc
	}
	
	// MARK: Oficialecoj
	
	func fariOficialecoListon(prezentilo: UINavigationController) -> KategoriaViewController {
		let listeroj = datumbazo.chiujOficialecoj.map { ofc in
			KategoriaViewController.Listero(
				teksto: ofc.nomo,
				celPagho: { [unowned self] in
					fariOficialecaVortliston(por: ofc, prezentilo: prezentilo)
				}
			)
		}
		return KategoriaViewController(listeroj: listeroj)
	}
	
	func fariOficialecaVortliston(
		por ofc: Oficialeco,
		prezentilo: UINavigationController
	) -> VortoListoViewController {
		let vc = VortoListoViewController { [weak self] listero in
			guard let self,
				  listero.destinoj.count == 1,
				  let celo = listero.destinoj.first else {
				return
			}
			
			prezentiArtikolonElDestino(celo, prezentilo)
		}
		
		let destinoj = datumbazo.ofcVortoj(oficialeco: ofc.kodo)
		vc.montri(listerojn: destinoj.map {
			VortoListoViewController.Listero(
				teksto: $0.teksto,
				subteksto: nil,
				destinoj: [$0]
			)
		})
		
		return vc
	}
	
	// MARK: Alia
	
	func fariHazardanArtikolon() -> ArtikoloViewController {
		let artikolo = datumbazo.iuAjnArtikolo()!
		
		return ArtikoloViewController(
			artikolo: artikolo,
			tradukLingvoj: uzantDatumaro.lingvoj,
			aperis: nil
		)
	}
}
