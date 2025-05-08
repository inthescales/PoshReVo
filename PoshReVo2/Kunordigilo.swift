import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(uzantDatumaro: .komuna)
	
	// MARK: Sub-kunordigiloj
	
	lazy var vortListoj: VortListoKunordigilo = {
		let kunordigilo = VortListoKunordigilo(
			prezentiArtikolon: prezentiArtikoloPaghon,
			prezentiArtikolonElDestino: prezentiArtikoloPaghon
		)
		return kunordigilo
	}()
	
	// MARK: Agordoj
	
	let uzantDatumaro: UzantDatumaro
	
	//
	
	init(uzantDatumaro: UzantDatumaro) {
		self.uzantDatumaro = uzantDatumaro
	}
	
	// MARK: Interfaceroj
	
	func fariLingvoBreton(
		elektisLingvon: @escaping (Lingvo) -> (),
		redaktisLingvojn: @escaping([Lingvo]) -> ()
	) -> LingvoBretoViewController {
		return LingvoBretoViewController(
			elektisLingvon: { [weak self] lingvo in
				self?.uzantDatumaro.elektis(lingvon: lingvo)
				elektisLingvon(lingvo)
			},
			redaktisLingvojn: { lingvoj in
				redaktisLingvojn(lingvoj)
			}
		)
	}
	
	// MARK: Paĝo-kreado
	
	func prezentiLingvoRedaktilon(
		prezentilo: UINavigationController,
		kompleti: @escaping ([Lingvo]) -> ()
	) {
		let navigaciilo = UINavigationController()
		navigaciilo.navigationBar.isTranslucent = false
		navigaciilo.navigationBar.backgroundColor = InterfacStilo.nuna.koloraFono // TODO: movi, korekti stilon
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: uzantDatumaro.lingvoj,
			kompleti: { [weak self] novaj in
				self?.uzantDatumaro.redaktisLingvojn(novaj: novaj)
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
		
		let vc = ArtikoloViewController(
			artikolo: artikolo,
			tradukLingvoj: uzantDatumaro.lingvoj,
			aperis: { [weak self] in
				self?.purigi(prezentilon: prezentilo)
			}
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiArtikoloPaghon(el artikolo: Artikolo, prezentilo: UINavigationController) {
		let vc = ArtikoloViewController(
			artikolo: artikolo,
			tradukLingvoj: uzantDatumaro.lingvoj,
			aperis: { [weak self] in
				self?.purigi(prezentilon: prezentilo)
			}
		)
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
	
	func prezentiSerchPaghon(prezentilo: UINavigationController, radika: Bool = false) {
		let serchilo = SerchoViewController(
			serchLingvoj: uzantDatumaro.lingvoj,
			radika: radika
		)
		prezentilo.pushViewController(
			serchilo,
			animated: true
		)
	}
	
	// MARK: Helpiloj
	
	/// Forigi kromajn serĉpaĝojn en la staplo da view controller-oj.
	/// Serĉilo restos se ĝi 1) estas la originala 'radika' serĉilo, aŭ 2) ĝi estas la plej lasta, starante antaŭ nune montrata artikolo
	private func purigi(prezentilon prezentilo: UINavigationController) {
		guard prezentilo.viewControllers.count >= 2 else {
			return
		}
		
		let antaulasta = prezentilo.viewControllers[prezentilo.viewControllers.count - 2]
		prezentilo.viewControllers = prezentilo.viewControllers.filter { vc in
			if let serchilo = vc as? SerchoViewController {
				return serchilo.radika || serchilo == antaulasta
			}
			
			return true
		}
	}
}
