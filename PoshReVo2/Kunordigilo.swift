import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(datumRegilo: .komuna, vortaro: .komuna)
		
	// MARK: Agordoj
	
	let datumRegilo: UzantDatumoRegilo
	
	let vortaro: VortaroDatumbazo
	
	//
	
	init(datumRegilo: UzantDatumoRegilo, vortaro: VortaroDatumbazo) {
		self.datumRegilo = datumRegilo
		self.vortaro = vortaro
	}
	
	// MARK: - Interfaceroj
	
	func fariLingvoBreton(
		elektisLingvon: @escaping (Lingvo) -> (),
		redaktisLingvojn: @escaping([Lingvo]) -> ()
	) -> LingvoBretoViewController {
		return LingvoBretoViewController(
			elektisLingvon: { [weak self] lingvo in
				self?.datumRegilo.elektis(lingvon: lingvo)
				elektisLingvon(lingvo)
			},
			redaktisLingvojn: { lingvoj in
				redaktisLingvojn(lingvoj)
			}
		)
	}
	
	// MARK: - Navigaciado
	
	func reveniHejmen(en navigaciilo: UINavigationController) {
		navigaciilo.popToRootViewController(animated: true)
		
		if let paghingo = navigaciilo.viewControllers.first as? PaghingoViewController {
			paghingo.restarigi()
		}
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
				teksto: Tekstoj.vortarajMallongigoj,
				celPagho: {
					MallongigoListoViewController(
						titolo: Tekstoj.vortarajMallongigoj,
						eroj: MallongigoListo.vortaraj
					)
				}
			),
			.init(
				teksto: Tekstoj.fakajMallongigoj,
				celPagho: {
					MallongigoListoViewController(
						titolo: Tekstoj.fakajMallongigoj,
						eroj: MallongigoListo.fakaj
					)
				}
			)
		]
		
		let vc = KategoriaViewController(
			titolo: Tekstoj.mallongigoj,
			tabelStilo: .insetGrouped,
			listeroj: listeroj
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	func prezentiInformoPaghon(
		prezentilo: UINavigationController
	) {
		let agordilo = InformojViewController()
		prezentilo.pushViewController(agordilo, animated: true)
	}
	
	func prezentiStiloelektilon(
		prezentilo: UINavigationController,
		elektis: @escaping (InterfacStilo) -> Void
	) {
		let navigaciilo = UINavigationController()
		navigaciilo.navigationBar.isTranslucent = false
		navigaciilo.navigationBar.backgroundColor = datumRegilo.datumaro.stilo.navigaciaFono // TODO: movi, korekti stilon
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let elektilo = StiloElektiloViewController() { [weak self] novaStilo in
			navigaciilo.dismiss(animated: true)
			
			if let novaStilo {
				self?.datumRegilo.meti(stilon: novaStilo)
				elektis(novaStilo)
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
		navigaciilo.navigationBar.backgroundColor = datumRegilo.datumaro.stilo.navigaciaFono
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: datumRegilo.datumaro.lingvoj,
			kompleti: { [weak self] novaj in
				self?.datumRegilo.redaktisLingvojn(novaj: novaj)
				kompleti(novaj)
				navigaciilo.dismiss(animated: true)
			}
		)
		
		navigaciilo.viewControllers = [redaktilo]
		navigaciilo.modalPresentationStyle = .fullScreen
		
		prezentilo.present(navigaciilo, animated: true)
	}
	
	func prezentiArtikoloPaghon(el destino: Destino, prezentilo: UINavigationController) {
		guard let artikolo = vortaro.artikolo(de: destino) else {
			fatalError("Artikolo ne ekzistas") // TODO: Ŝanĝi tion ĉi
		}
		
		let vc = fariArtikoloPaghon(el: artikolo, marko: destino.marko, prezentilo: prezentilo)
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
			// Se mankas subteksto, disigi per artikol-titolo
			// — aparte utila ĉe esperantaj vortoj ekz. 'far/ad/o' / 'farad/o'
			let subteksto = destino.subteksto
				?? vortaro.artikolo(de: destino)?.titolo
				?? nil
			
			return Serchlistero(teksto: destino.teksto, subteksto: subteksto, destinoj: [destino])
		}
		
		disigilo.montri(listerojn: listeroj)
		
		prezentilo.pushViewController(disigilo, animated: true)
	}
	
	func prezentiSerchPaghon(prezentilo: UINavigationController, radika: Bool = false) {
		let serchilo = SerchoViewController(
			serchLingvoj: datumRegilo.datumaro.lingvoj,
			radika: radika
		)
		prezentilo.pushViewController(
			serchilo,
			animated: true
		)
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
			uzantDatumaro: datumRegilo.datumaro
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
			uzantDatumaro: datumRegilo.datumaro
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	// MARK: - Esploraĵoj
	
	func prezentiEsplorMenuon(prezentilo: UINavigationController) {
		let sekcioj = [
			KategoriaViewController.Sekcio(
				titolo: Tekstoj.kategorioj,
				eroj: [
					.init(
						teksto: Tekstoj.fakoj,
						celPagho: { [unowned self] in fariFakListon(prezentilo: prezentilo) }
					),
					.init(
						teksto: Tekstoj.oficialecoj,
						celPagho: { [unowned self] in fariOficialecoListon(prezentilo: prezentilo) }
					)
				]
			),
			KategoriaViewController.Sekcio(
				titolo: nil,
				eroj: [
					.init(
						teksto: Tekstoj.hazardaArtikolo,
						celPagho: { [unowned self] in fariHazardanArtikolon() }
					)
				]
			)
		]
		
		let vc = KategoriaViewController(
			titolo: Tekstoj.esplori,
			tabelStilo: .insetGrouped,
			sekcioj: sekcioj
		)
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
		return KategoriaViewController(titolo: Tekstoj.fakoj, listeroj: listeroj)
	}
	
	func fariFakVortliston(
		por fako: Fako,
		prezentilo: UINavigationController
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero>(titolo: fako.nomo) { [weak self] listero in
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
		return KategoriaViewController(titolo: Tekstoj.oficialecoj, listeroj: listeroj)
	}
	
	func fariOficialecaVortliston(
		por ofc: Oficialeco,
		prezentilo: UINavigationController
	) -> VortoListoViewController<Esplorlistero> {
		let vc = VortoListoViewController<Esplorlistero>(titolo: ofc.nomo) { [weak self] listero in
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
			aperis: { [weak self] in self?.datumRegilo.markiVizititan(artikolon: artikolo) },
			konservis: { [weak self] konservita in
				guard let self else { return }
				
				if konservita {
					datumRegilo.konservi(artikolon: artikolo)
				} else {
					datumRegilo.malkonservi(artikolon: artikolo)
				}
			},
			uzantDatumaro: datumRegilo.datumaro
		)
	}
	
	// MARK: - Paĝhelpiloj
	
	private func fariArtikoloPaghon(
		el artikolo: Artikolo,
		marko: String? = nil,
		prezentilo: UINavigationController
	) -> ArtikoloViewController {
		ArtikoloViewController(
			artikolo: artikolo,
			marko: marko,
			aperis: { [weak self] in
				self?.datumRegilo.markiVizititan(artikolon: artikolo)
			},
			konservis: { [weak self] konservita in
				guard let self else { return }
				
				if konservita {
					datumRegilo.konservi(artikolon: artikolo)
				} else {
					datumRegilo.malkonservi(artikolon: artikolo)
				}
			},
			uzantDatumaro: datumRegilo.datumaro
		)
	}
}
