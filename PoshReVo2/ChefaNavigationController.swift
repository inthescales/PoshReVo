import UIKit

final class ChefaNavigationController: UINavigationController {
	override func viewDidLoad() {
		navigationBar.isTranslucent = false
		navigationBar.tintColor = DinamikaStilo.navigaciaButono
		
		let navigacejAspekto = UINavigationBarAppearance()
		navigacejAspekto.configureWithOpaqueBackground()
		navigacejAspekto.backgroundColor = DinamikaStilo.navigaciaFono
		navigacejAspekto.shadowColor = .none
		navigacejAspekto.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor : DinamikaStilo.navigaciaTeksto
		]
		UINavigationBar.appearance().standardAppearance = navigacejAspekto
		UINavigationBar.appearance().compactAppearance = navigacejAspekto
		UINavigationBar.appearance().scrollEdgeAppearance = navigacejAspekto
	}
}
