import UIKit

import ReVoDatumbazo

final class VortListoKunordigilo {
	// MARK: Agordoj
	
	let prezentiArtikolon: (Destino, UINavigationController) -> ()
	
	//
	
	init(prezentiArtikolon: @escaping (Destino, UINavigationController) -> ()) {
		self.prezentiArtikolon = prezentiArtikolon
	}
	
	// MARK: Fakoj
	
	func prezentiFakoListon(prezentilo: UINavigationController) {
		let listeroj = VortaroDatumbazo.komuna.chiujFakoj.map { fako in
			KategoriaViewController.Listero(
				teksto: fako.nomo,
				celPagho: { [unowned self] in
					fariFakVortliston(por: fako, prezentilo: prezentilo)
				}
			)
		}
		let vc = KategoriaViewController(listeroj: listeroj)
		prezentilo.pushViewController(vc, animated: true)
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
			
			prezentiArtikolon(celo, prezentilo)
		}
		
		let destinoj = VortaroDatumbazo.komuna.fakVortoj(fako: fako.kodo)
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
	
	func prezentiOficialecoListon(prezentilo: UINavigationController) {
		let listeroj = VortaroDatumbazo.komuna.chiujOficialecoj.map { ofc in
			KategoriaViewController.Listero(
				teksto: ofc.nomo,
				celPagho: { [unowned self] in
					fariOficialecaVortliston(por: ofc, prezentilo: prezentilo)
				}
			)
		}
		let vc = KategoriaViewController(listeroj: listeroj)
		prezentilo.pushViewController(vc, animated: true)
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
			
			prezentiArtikolon(celo, prezentilo)
		}
		
		let destinoj = VortaroDatumbazo.komuna.ofcVortoj(oficialeco: ofc.kodo)
		vc.montri(listerojn: destinoj.map {
			VortoListoViewController.Listero(
				teksto: $0.teksto,
				subteksto: nil,
				destinoj: [$0]
			)
		})
		
		return vc
	}
}
