import UIKit

/// Propra UINavigationController klaso uzata ĉie en ĉi-apo.
/// Enhavas kelkajn stilajn kapablojn
final class PRVNavigationController: UINavigationController {
	private var stilo: InterfacStilo {
		UzantDatumaro.komuna.stilo
	}
	
	override func viewDidLoad() {
		navigationBar.isTranslucent = false
		ghisdatigiAspekton(topViewController)
	}
	
	/// Ĝisdatigi la aspekton de la navigation controller
	/// Vokatas kiam nova paĝo aperas por ke la ambro povu aperu aŭ ne aperu laŭ la paĝo
	private func ghisdatigiAspekton(_ vc: UIViewController?) {
		let navigacejAspekto = UINavigationBarAppearance()
		navigacejAspekto.configureWithOpaqueBackground()
		navigacejAspekto.backgroundColor = stilo.navigaciaFono
		navigationBar.tintColor = stilo.navigaciaButono
		
		let efektivaVC = efektivaVC(de: vc) ?? UIViewController()
		
		// Meti ombrokoloron se la koloraro bezonas ĝin.
		// Por eviti situacion en kiu ŝanĝiĝo de aparat-heleco kaŭzus misan
		// ombron (ĉar la koloraro de unu heleco bezonus ĝin kaj la alia ne)
		// ni metas specialan dinamikan koloron
		let chuHelaOmbro = chuMontriOmbron(por: efektivaVC, kun: stilo.hela)
		let chuMalhelaOmbro = chuMontriOmbron(por: efektivaVC, kun: stilo.malhela)
		navigacejAspekto.shadowColor =  UIColor(
			hela: chuHelaOmbro ? stilo.hela.ombro : stilo.hela.navigaciaFono,
			malhela: chuMalhelaOmbro ? stilo.malhela.ombro : stilo.malhela.navigaciaFono
		)
		
		navigacejAspekto.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor : stilo.navigaciaTeksto
		]
		
		// Necesas por present-itaj VCoj
		UINavigationBar.appearance().standardAppearance = navigacejAspekto
		UINavigationBar.appearance().compactAppearance = navigacejAspekto
		UINavigationBar.appearance().scrollEdgeAppearance = navigacejAspekto

		// Necesas por push-itaj VCoj
		navigationBar.standardAppearance = navigacejAspekto
		navigationBar.compactAppearance = navigacejAspekto
		navigationBar.scrollEdgeAppearance = navigacejAspekto
	}
	
	// MARK: - Helpiloj
	
	/// La efektive montrata VC, ignoranta ingojn
	private func efektivaVC(de vc: UIViewController?) -> UIViewController? {
		if let ingo = vc as? PaghingoViewController {
			return ingo.chefpagho
		} else {
			return vc
		}
	}
	
	/// Decidi ĉu ombro montriĝu sub la navigacitabulo en tiu VC, havanta tiun koloron.
	private func chuMontriOmbron(por vc: UIViewController?, kun koloraro: Koloraro) -> Bool {
		guard let vc else {
			return true
		}
		
		for suba in vc.view.subviews {
			// Ne montro ombron se serĉilo pendas de la navigaciejo
			if suba is SerchiloView {
				return false
			}
			
			// Ne montru ombron se la paĝo estas 'plata' menuo.
			// Tio estas, menuo ĉe kiu la navigaciejo kaj la ĉefa fonoj estas samkoloraj
			if let tabelo = suba as? UITableView,
			   (tabelo.style == .insetGrouped || tabelo.style == .grouped)
				&& koloraro.menuoFono.cgColor == koloraro.navigaciaFono.cgColor {
				return false
			}
		}
		
		return true
	}
	
	// MARK: - Trapasfunkcioj
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		ghisdatigiAspekton(topViewController)
	}
	
	override func pushViewController(_ vc: UIViewController, animated: Bool) {
		super.pushViewController(vc, animated: animated)
		ghisdatigiAspekton(topViewController)
	}
	
	override func popViewController(animated: Bool) -> UIViewController? {
		let vc = super.popViewController(animated: animated)
		ghisdatigiAspekton(topViewController)
		
		return vc
	}
	
	override func popToRootViewController(animated: Bool) -> [UIViewController]? {
		let VCoj = super.popToRootViewController(animated: animated)
		ghisdatigiAspekton(topViewController)
		
		return VCoj
	}
	
	// MARK: - Avizreagoj
	@objc private func stiloShanghighis() {
		ghisdatigiAspekton(topViewController)
	}
}
