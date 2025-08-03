import UIKit

final class ChefaNavigationController: UINavigationController {
	/// View Controller-aj klasoj kiuj NE montru ombro-strekon sube
	private let senombrajVCoj: [Any.Type] = [
		SerchoViewController.self,
		KategoriaViewController.self,
		MallongigoListoViewController.self,
		LingvoElektiloViewController.self,
		AgordojViewController.self,
		StiloElektiloViewController.self
	]
	
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
		let montriOmbron = !senombrajVCoj.contains(where: { type(of: veraVC) == $0 })
		navigacejAspekto.shadowColor = montriOmbron ? DinamikaStilo.ombro : nil
		
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
