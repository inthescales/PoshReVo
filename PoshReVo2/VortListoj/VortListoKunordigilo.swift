import UIKit

import ReVoDatumbazo

final class VortListoKunordigilo {
	// MARK: Agordoj
	
	let prezentiArtikolon: (Artikolo, UINavigationController) -> ()
	
	let prezentiArtikolonElDestino: (Destino, UINavigationController) -> ()
	
	let datumbazo: VortaroDatumbazo
	
	//
	
	init(
		prezentiArtikolon: @escaping (Artikolo, UINavigationController) -> (),
		prezentiArtikolonElDestino: @escaping (Destino, UINavigationController) -> (),
		datumbazo: VortaroDatumbazo = .komuna
	) {
		self.prezentiArtikolon = prezentiArtikolon
		self.prezentiArtikolonElDestino = prezentiArtikolonElDestino
		self.datumbazo = datumbazo
	}
	
	// MARK: Fakoj
	
	func prezentiFakoListon(prezentilo: UINavigationController) {
		let listeroj = datumbazo.chiujFakoj.map { fako in
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
	
	func prezentiOficialecoListon(prezentilo: UINavigationController) {
		let listeroj = datumbazo.chiujOficialecoj.map { ofc in
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
	
	func prezentiHazardanArtikolon(prezentilo: UINavigationController) {
		guard let artikolo = datumbazo.iuAjnArtikolo() else { return }
		prezentiArtikolon(artikolo, prezentilo)
	}
}
