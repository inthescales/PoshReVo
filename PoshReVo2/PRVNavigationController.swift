import UIKit

/// Propra UINavigationController klaso uzata ĉie en ĉi-apo.
/// Enhavas kelkajn stilajn kapablojn
final class PRVNavigationController: UINavigationController {
	override func viewDidLoad() {
		navigationBar.isTranslucent = false
		navigationBar.tintColor = DinamikaStilo.navigaciaButono
		ghisdatigiAspekton(topViewController)
	}
	
	/// Ĝisdatigi la aspekton de la navigation controller
	/// Vokatas kiam nova paĝo aperas por ke la ambro povu aperu aŭ ne aperu laŭ la paĝo
	private func ghisdatigiAspekton(_ vc: UIViewController?) {
		let navigacejAspekto = UINavigationBarAppearance()
		navigacejAspekto.configureWithOpaqueBackground()
		navigacejAspekto.backgroundColor = DinamikaStilo.navigaciaFono
		
		let veraVC = veraVC(de: vc) ?? UIViewController()
		navigacejAspekto.shadowColor = chuMontriOmbron(por: veraVC) ? DinamikaStilo.ombro : nil
		
		navigacejAspekto.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor : DinamikaStilo.navigaciaTeksto
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
	
	/// La vere montrata VCo, ignoranta ingojn
	private func veraVC(de vc: UIViewController?) -> UIViewController? {
		if let ingo = vc as? PaghingoViewController {
			return ingo.chefpagho
		} else {
			return vc
		}
	}
	
	/// Decidi ĉu ombro montriĝu sub la navigacitabulo.
	private func chuMontriOmbron(por vc: UIViewController?) -> Bool {
		// NOTO:
		// Eta malsukcesa kazo: ŝanĝo de aparat-heleco povas kaŭzi misan staton,
		// se la hela kaj malhela stiloj donus malsaman rezulton ĉi tie.
		
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
			   && tabelo.backgroundColor?.cgColor == UzantDatumaro.komuna.stilo.navigaciaFono.cgColor {
				return false
			}
		}
		
		return true
	}
	
	// MARK: - Trapasfunkcioj
	
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
	
	override func present(
		_ viewControllerToPresent: UIViewController,
		animated flag: Bool,
		completion: (() -> Void)? = nil
	) {
		super.present(viewControllerToPresent, animated: flag, completion: completion)
		ghisdatigiAspekton(topViewController)
	}
}
