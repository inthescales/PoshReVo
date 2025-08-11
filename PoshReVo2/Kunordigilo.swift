import UIKit

import ReVoDatumbazo

// TODO: Eble dividi ĉi-klason en plurajn

/// Regas la kreadon kaj presentadon de ĉiuj paĝoj en la apo, kaj provisas ilin je datumoj laŭnecese
final class Kunordigilo {
	static var komuna = Kunordigilo(datumRegilo: .komuna, vortaro: .komuna)
		
	// MARK: - Agordoj
	
	private let datumRegilo: UzantDatumoRegilo
	
	private let vortaro: VortaroDatumbazo
	
	// MARK: - Valorizado
	
	init(datumRegilo: UzantDatumoRegilo, vortaro: VortaroDatumbazo) {
		self.datumRegilo = datumRegilo
		self.vortaro = vortaro
	}
	
	// MARK: - Navigaciado
	
	/// Forigas ĉiujn paĝoj sur la navigacia staplo ĝis la unua, kaj restarigas la hejman paĝon
	func reveniHejmen(en navigaciilo: UINavigationController) {
		navigaciilo.popToRootViewController(animated: true)
		
		if let paghingo = navigaciilo.viewControllers.first as? PaghingoViewController {
			paghingo.restarigi()
		}
	}
	
	// MARK: - Artikoloj
	
	/// Prezentas paĝon de la artikolo
	func prezentiArtikoloPaghon(
		el artikolo: Artikolo,
		marko: String? = nil,
		prezentilo: UINavigationController
	) {
		let vc = fariArtikoloPaghon(el: artikolo, marko: marko)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	/// Prezentas paĝon de la artikolo de la destino
	func prezentiArtikoloPaghon(el destino: Destino, prezentilo: UINavigationController) {
		guard let artikolo = vortaro.artikolo(de: destino) else {
			fatalError("Artikolo ne ekzistas") // TODO: Montri eraron
		}
		
		let vc = fariArtikoloPaghon(el: artikolo, marko: destino.marko)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	// MARK: - Serĉado
	
	/// Prezentas disigilan paĝon por la destinoj
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
	
	// MARK: - Agordoj
	
	/// Prezentas agordopaĝon
	func prezentiAgordMenuon(
		prezentilo: UINavigationController
	) {
		let agordilo = AgordojViewController()
		prezentilo.pushViewController(agordilo, animated: true)
	}
	
	/// Puŝas lingvoredaktilan paĝon.
	/// Uzata en la agordopaĝo.
	func pushiLingvoRedaktilon(
		prezentilo: UINavigationController,
		elektis: @escaping ([Lingvo]) -> ()
	) {
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: datumRegilo.datumaro.lingvoj,
			prezentManiero: .pushita,
			elektis: { [weak self] novaj in
				self?.datumRegilo.redaktisLingvojn(novaj: novaj)
				elektis(novaj)
			}
		)
		
		prezentilo.pushViewController(redaktilo, animated: true)
	}
	
	/// Puŝas lingvoredaktilan paĝon.
	/// Uzata en la lingvobreto kaj en artikoloj
	func prezentiLingvoRedaktilon(
		prezentilo: UINavigationController,
		kompleti: @escaping ([Lingvo]) -> ()
	) {
		let navigaciilo = PRVNavigationController()
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: datumRegilo.datumaro.lingvoj,
			prezentManiero: .prezentita(forigi: {
				navigaciilo.dismiss(animated: true)
			}),
			elektis: { [weak self] novaj in
				self?.datumRegilo.redaktisLingvojn(novaj: novaj)
				kompleti(novaj)
			}
		)
		
		navigaciilo.viewControllers = [redaktilo]
		navigaciilo.modalPresentationStyle = .fullScreen
		
		prezentilo.present(navigaciilo, animated: true)
	}
	
	func prezentiLingvoElektilon(
		prezentilo: UINavigationController,
		kromEsperanto: Bool,
		jamElektitaj: [Lingvo],
		elektisLingvon: @escaping (Lingvo) -> Void
	) {
		let elektiloVC = LingvoElektiloViewController(
			kromEsperanto: kromEsperanto,
			jamElektitaj: jamElektitaj,
			elektisLingvon: elektisLingvon
		)
		let navigaciilo = PRVNavigationController(rootViewController: elektiloVC)
		navigaciilo.modalPresentationStyle = .fullScreen
		
		prezentilo.present(navigaciilo, animated: true)
	}
	
	/// Prezentas stiloelektilan paĝon
	func prezentiStiloelektilon(
		prezentilo: UINavigationController,
		elektis: @escaping (InterfacStilo) -> Void
	) {
		let navigaciilo = PRVNavigationController()
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
	
	// MARK: - Uzantaj vortlistoj
	
	/// Prezentas liston da vizititaj artikoloj
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
	
	/// Prezentas liston da konservitaj artikoloj
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
	
	/// Prezentas la esplorpaĝon
	func prezentiEsplorMenuon(prezentilo: UINavigationController) {
		let sekcioj = [
			KategoriaViewController.Sekcio(
				titolo: Tekstoj.kategorioj,
				eroj: [
					.init(
						teksto: Tekstoj.fakoj,
						celPagho: { [unowned self] in fariFaklistanPaghon(prezentilo: prezentilo) }
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
						celPagho: { [unowned self] in
							let artikolo = vortaro.iuAjnArtikolo()! // TODO: Montri eraron se necesas
							return fariArtikoloPaghon(el: artikolo, marko: nil)
						}
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
	
	/// Kreas paĝon montranta fakojn, per kiu uzanto povu atingi fakvortojn
	private func fariFaklistanPaghon(prezentilo: UINavigationController) -> KategoriaViewController {
		return KategoriaViewController.fakListo(
			vortaro: vortaro,
			elektisArtikolon:  { [weak self] destino in
				self?.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
			}
		)
	}
	
	/// Kreas paĝon montranta oficialecojn, per kiu uzanto povu atingi ofcvortojn
	func fariOficialecoListon(prezentilo: UINavigationController) -> KategoriaViewController {
		return KategoriaViewController.oficialecoListo(
			vortaro: vortaro,
			elektisArtikolon:  { [weak self] destino in
				self?.prezentiArtikoloPaghon(el: destino, prezentilo: prezentilo)
			}
		)
	}
	
	// MARK: - Mallongigoj kaj Informoj
	
	/// Prezentas menuon por montri mallongigo-difinojn
	func prezentiMallongigoMenuon(prezentilo: UINavigationController) {
		let sekcioj: [KategoriaViewController.Sekcio] = [
			.init(
				titolo: nil,
				eroj: [
					.init(
						teksto: Tekstoj.vortarajMallongigoj,
						celPagho: {
							MallongigoListoViewController(
								titolo: Tekstoj.vortarajMallongigoj,
								eroj: MallongigoListoj.vortaraj
							)
						}
					),
					.init(
						teksto: Tekstoj.fakajMallongigoj,
						celPagho: {
							MallongigoListoViewController(
								titolo: Tekstoj.fakajMallongigoj,
								eroj: MallongigoListoj.fakaj
							)
						}
					),
					.init(
						teksto: Tekstoj.bibliografio,
						celPagho: {
							MallongigoListoViewController(
								titolo: Tekstoj.bibliografio,
								eroj: MallongigoListoj.bibliografiaj
							)
						}
					)
				]
			),
			.init(
				titolo: nil,
				eroj: [
					.init(
						teksto: Tekstoj.chiujMallongigoj,
						celPagho: {
							MallongigoListoViewController(
								titolo: Tekstoj.chiujMallongigoj,
								eroj: MallongigoListoj.chiuj
							)
						}
					)
				]
			)
		]
		
		let vc = KategoriaViewController(
			titolo: Tekstoj.mallongigoj,
			tabelStilo: .insetGrouped,
			sekcioj: sekcioj
		)
		prezentilo.pushViewController(vc, animated: true)
	}
	
	/// Prezenti paĝon montranta informojn pri ReVo kaj PoŝReVo
	func prezentiInformoPaghon(
		prezentilo: UINavigationController
	) {
		let agordilo = InformojViewController()
		prezentilo.pushViewController(agordilo, animated: true)
	}
	
	// MARK: - Paĝokreadaj helpiloj
	
	/// Liveras novan serĉpaĝon
	func fariSerchPaghon() -> SerchoViewController{
		SerchoViewController(
			serchLingvoj: datumRegilo.datumaro.lingvoj,
			elektisLingvon: { [weak self] lingvo in self?.datumRegilo.elektis(lingvon: lingvo)}
		)
	}
	
	/// Liveras novan artikolpaĝon el artikol-objekto
	private func fariArtikoloPaghon(
		el artikolo: Artikolo,
		marko: String? = nil
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
