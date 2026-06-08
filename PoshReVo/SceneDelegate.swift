import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var fenestro: UIWindow?
	
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		// Aserti ke la sceno estas fenestra sceno en iOS aŭ iPadOS
		guard let windowScene = scene as? UIWindowScene else { assert(false) }
				
		// Starigi hejmpaĝon
		let serchPagho = Kunordigilo.komuna.fariSerchPaghon()
		let vc = PaghingoViewController(chefpagho: serchPagho)
		let navigaciilo = PRVNavigationController(rootViewController: vc)
		fenestro = UIWindow(windowScene: windowScene)
		fenestro?.rootViewController = navigaciilo
		fenestro?.makeKeyAndVisible()
	}
}
