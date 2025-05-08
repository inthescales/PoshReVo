import UIKit

import ReVoDatumbazo

final class VortListoKunordigilo {
	// MARK: Agordoj
	
	let prezentiArtikolon: (Destino, UINavigationController) -> ()
	
	//
	
	init(prezentiArtikolon: @escaping (Destino, UINavigationController) -> ()) {
		self.prezentiArtikolon = prezentiArtikolon
	}
	
	func prezentiOficialecoListon(prezentilo: UINavigationController) {
		let listeroj = VortaroDatumbazo.komuna.chiujOficialecoj?.map { ofc in
			KategoriaViewController.Listero(
				teksto: ofc.nomo,
				celPagho: { [unowned self] in
					fariOficialecaVortlisto(por: ofc, prezentilo: prezentilo)
				}
			)
		} ?? []
		let vc = KategoriaViewController(listeroj: listeroj)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func fariOficialecaVortlisto(
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
