import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(uzantDatumaro: .komuna, vortaro: .komuna)
		
	// MARK: Agordoj
	
	let uzantDatumaro: UzantDatumaro
	
	let vortaro: VortaroDatumbazo
	
	//
	
	init(uzantDatumaro: UzantDatumaro, vortaro: VortaroDatumbazo) {
		self.uzantDatumaro = uzantDatumaro
		self.vortaro = vortaro
	}
	
	// MARK: - Interfaceroj
	
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
	
	func prezentiAgordMenuon(
		prezentilo: UINavigationController
	) {
		let agordilo = AgordojViewController()
		prezentilo.pushViewController(agordilo, animated: true)
	}
	
	func prezentiMallongigoMenuon(prezentilo: UINavigationController) {
		let listeroj: [KategoriaViewController.Listero] = [
			.init(
				teksto: "Vortaraj Mallongigoj",
				celPagho: { MallongigoListoViewController(eroj: MallongigoListo.vortaraj) }
			),
			.init(
				teksto: "Fakaj Mallongigoj",
				celPagho: { MallongigoListoViewController(eroj: MallongigoListo.fakaj) }
			)
		]
		
		let vc = KategoriaViewController(listeroj: listeroj)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func fariMallongigoPaghon(
		mallongigoj: [MallongigoListoViewController.Ero],
		prezentilo: UINavigationController
	) -> MallongigoListoViewController {
		return MallongigoListoViewController(eroj: mallongigoj)
	}
	
	func prezentiInformoPaghon(
		prezentilo: UINavigationController
	) {
		let agordilo = InformojViewController()
		prezentilo.pushViewController(agordilo, animated: true)
	}
	
	func prezentiStiloelektilon(
		prezentilo: UINavigationController
	) {
		let navigaciilo = UINavigationController()
		navigaciilo.navigationBar.isTranslucent = false
		navigaciilo.navigationBar.backgroundColor = InterfacStilo.nuna.koloraFono // TODO: movi, korekti stilon
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let elektilo = StiloElektiloViewController() { novaStilo in
			navigaciilo.dismiss(animated: true)
			
			if let novaStilo {
				InterfacStilo.nuna = novaStilo
			}
		}
		navigaciilo.viewControllers = [elektilo]
		navigaciilo.modalPresentationStyle = .fullScreen
		
		prezentilo.present(navigaciilo, animated: true)
	}
	
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
		
		let vc = fariArtikoloPaghon(el: artikolo, prezentilo: prezentilo)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiArtikoloPaghon(el artikolo: Artikolo, prezentilo: UINavigationController) {
		let vc = fariArtikoloPaghon(el: artikolo, prezentilo: prezentilo)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiDisigiloPaghon(
		por destinoj: [Destino],
		prezentilo: UINavigationController,
		elektis: @escaping (Destino) -> ()
	) {
		let disigilo = VortoListoViewController<Serchlistero>(
			elektis: { listero in
				guard let destino = listero.destinoj.first else {
					return
				}
				
				elektis(destino)
			}
		)
		
		let listeroj = destinoj.map { destino in
			Serchlistero(teksto: destino.teksto, subteksto: destino.subteksto, destinoj: [destino])
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
	
	// MARK: - Uzantaj vortlistoj
	
	func prezentiHistorion(prezentilo: UINavigationController) {
		let vc = HistorioViewController(
			elektis: { [weak self] listero in
				guard let self,
					  let artikolo = vortaro.artikolo(indekso: listero.indekso) else {
					return
				}
				
				prezentiArtikoloPaghon(el: artikolo, prezentilo: prezentilo)
			},
			uzantDatumaro: uzantDatumaro
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiKonservitajn(prezentilo: UINavigationController) {
		let vc = KonservitajViewController(
			elektis: { [weak self] listero in
				guard let self,
					  let artikolo = vortaro.artikolo(indekso: listero.indekso) else {
					return
				}
				
				prezentiArtikoloPaghon(el: artikolo, prezentilo: prezentilo)
			},
			uzantDatumaro: uzantDatumaro
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	// MARK: - Esploraĵoj
	
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
		let listeroj = vortaro.chiujFakoj.map { fako in
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
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero> { [weak self] listero in
			guard let self else { return }
			
			prezentiArtikoloPaghon(el: listero.destino, prezentilo: prezentilo)
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
	
	// MARK: Oficialecoj
	
	func fariOficialecoListon(prezentilo: UINavigationController) -> KategoriaViewController {
		let listeroj = vortaro.chiujOficialecoj.map { ofc in
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
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero> { [weak self] listero in
			guard let self else { return }
			
			prezentiArtikoloPaghon(el: listero.destino, prezentilo: prezentilo)
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
	
	// MARK: Alia
	
	func fariHazardanArtikolon() -> ArtikoloViewController {
		let artikolo = vortaro.iuAjnArtikolo()!
		
		return ArtikoloViewController(
			artikolo: artikolo,
			aperis: { [weak self] in self?.uzantDatumaro.vizitis(artikolon: artikolo) },
			konservis: { [weak self] konservita in
				guard let self else { return }
				
				if konservita {
					uzantDatumaro.konservi(artikolon: artikolo)
				} else {
					uzantDatumaro.malkonservi(artikolon: artikolo)
				}
			},
			uzantDatumaro: uzantDatumaro
		)
	}
	
	// MARK: - Paĝhelpiloj
	
	private func fariArtikoloPaghon(
		el artikolo: Artikolo,
		prezentilo: UINavigationController
	) -> ArtikoloViewController {
		ArtikoloViewController(
			artikolo: artikolo,
			aperis: { [weak self] in
				self?.uzantDatumaro.vizitis(artikolon: artikolo)
				self?.purigi(prezentilon: prezentilo)
			},
			konservis: { [weak self] konservita in
				guard let self else { return }
				
				if konservita {
					uzantDatumaro.konservi(artikolon: artikolo)
				} else {
					uzantDatumaro.malkonservi(artikolon: artikolo)
				}
			},
			uzantDatumaro: uzantDatumaro
		)
	}
}
