import UIKit

final class ChefaNavigationController: UINavigationController {
	override func viewDidLoad() {
		navigationBar.isTranslucent = false
		
		let navigacejAspekto = UINavigationBarAppearance()
		navigacejAspekto.configureWithOpaqueBackground()
		navigacejAspekto.backgroundColor = DinamikaStilo.navigaciaFono
		UINavigationBar.appearance().standardAppearance = navigacejAspekto
		UINavigationBar.appearance().compactAppearance = navigacejAspekto
		UINavigationBar.appearance().scrollEdgeAppearance = navigacejAspekto
	}
}
