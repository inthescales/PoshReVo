import UIKit

final class ChefaNavigationController: UINavigationController {
	override func viewDidLoad() {
		navigationBar.isTranslucent = false
		navigationBar.backgroundColor = InterfacStilo.nuna.koloraFono
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// Mi ne scias kial ĉi tio ne povas aperi en viewDidLoad, tamen tie ĝi ne funkcias
		let bildeto = UIImage(named: "libro")?
			.withRenderingMode(.alwaysTemplate)
		let bildoView = UIImageView(image: bildeto)
		bildoView.tintColor = InterfacStilo.nuna.senkoloraFono
		navigationBar.topItem?.titleView = bildoView
	}
}
