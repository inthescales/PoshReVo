import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(uzantDatumaro: .komuna)
	
	let uzantDatumaro: UzantDatumaro
	
	init(uzantDatumaro: UzantDatumaro) {
		self.uzantDatumaro = uzantDatumaro
	}
	
	// MARK: Paĝo-kreado
	
	func fariLingvoElektilon(kompleti: @escaping ([Lingvo]) -> ()) -> UINavigationController {
		let navigaciilo = UINavigationController()
		navigaciilo.navigationBar.isTranslucent = false
		navigaciilo.navigationBar.backgroundColor = InterfacStilo.nuna.koloraFono // TODO: movi, korekti stilon
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: uzantDatumaro.lingvoj,
			kompleti: { [unowned self] novaj in
				uzantDatumaro.redaktisLingvojn(novaj: novaj)
				kompleti(novaj)
				navigaciilo.dismiss(animated: true)
			}
		)
		
		navigaciilo.viewControllers = [redaktilo]
		
		return navigaciilo
	}
	
	func fariArtikoloPaghon(el destino: Destino) -> ArtikoloViewController {
		guard let artikolo = VortaroDatumbazo.komuna.artikolo(de: destino) else {
			fatalError("Artikolo ne ekzistas") // TODO: Ŝanĝi tion ĉi
		}
		
		return ArtikoloViewController(artikolo: artikolo)
	}
	
	func fariArtikoloPaghon(el artikolo: Artikolo) -> ArtikoloViewController {
		return ArtikoloViewController(artikolo: artikolo)
	}
	
	func fariDisigiloPaghon(
		por destinoj: [Destino],
		elektis: @escaping (Destino) -> ()
	) -> VortoListoViewController {
		let disigilo = VortoListoViewController(
			elektis: { listero in
				guard let destino = listero.destinoj.first else {
					return
				}
				
				elektis(destino)
			}
		)
		
		let listeroj = destinoj.map { destino in
			VortoListoViewController.Listero(teksto: destino.teksto, subteksto: destino.subteksto, destinoj: [destino])
		}
		disigilo.montri(listerojn: listeroj)
		
		return disigilo
	}
}
