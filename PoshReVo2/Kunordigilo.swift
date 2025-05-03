import UIKit

import ReVoDatumbazo

final class Kunordigilo {
	static var komuna = Kunordigilo(uzantDatumaro: .komuna)
	
	let uzantDatumaro: UzantDatumaro
	
	init(uzantDatumaro: UzantDatumaro) {
		self.uzantDatumaro = uzantDatumaro
	}
	
	// MARK: Paĝo-kreado
	
	func fariLingvoElektilon(kompleti: @escaping ([Lingvo]) -> ()) -> UINavigationController {
		let navigaciilo = UINavigationController()
		navigaciilo.navigationBar.isTranslucent = false
		navigaciilo.navigationBar.backgroundColor = InterfacStilo.nuna.koloraFono // TODO: movi, korekti stilon
		navigaciilo.modalPresentationStyle = .fullScreen
		
		let redaktilo = LingvaroRedaktiloViewController(
			lingvaro: uzantDatumaro.lingvoj,
			kompleti: { [unowned self] novaj in
				uzantDatumaro.redaktisLingvojn(novaj: novaj)
				kompleti(novaj)
				navigaciilo.dismiss(animated: true)
			}
		)
		
		navigaciilo.viewControllers = [redaktilo]
		
		return navigaciilo
	}
}
