import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(uzantDatumaro: .komuna)
	
	let uzantDatumaro: UzantDatumaro
	
	init(uzantDatumaro: UzantDatumaro) {
		self.uzantDatumaro = uzantDatumaro
	}
	
	// MARK: Paĝo-kreado
	
	func prezentiLingvoElektilon(
		prezentilo: UINavigationController,
		kompleti: @escaping ([Lingvo]) -> ()
	) {
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
		navigaciilo.modalPresentationStyle = .fullScreen
		
		prezentilo.present(navigaciilo, animated: true)
	}
	
	func prezentiArtikoloPaghon(el destino: Destino, prezentilo: UINavigationController) {
		guard let artikolo = VortaroDatumbazo.komuna.artikolo(de: destino) else {
			fatalError("Artikolo ne ekzistas") // TODO: Ŝanĝi tion ĉi
		}
		
		let vc = ArtikoloViewController(artikolo: artikolo)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiArtikoloPaghon(el artikolo: Artikolo, prezentilo: UINavigationController) {
		let vc = ArtikoloViewController(artikolo: artikolo)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiDisigiloPaghon(
		por destinoj: [Destino],
		prezentilo: UINavigationController,
		elektis: @escaping (Destino) -> ()
	) {
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
		
		prezentilo.pushViewController(disigilo, animated: true)
	}
}
