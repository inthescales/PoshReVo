import CoreData
import UIKit

import ReVoDatumbazo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var fenestro: UIWindow?

	/// Datumbaz-konteksto por ĉiuj datumbazaj operacioj
	lazy var datumbazKonteksto: NSManagedObjectContext = {
		let datumbazNomo = "PoshReVoDatumbazo"
		let bundleUrl = Bundle.main.url(forResource: datumbazNomo, withExtension: "sqlite")!
		return ReVoDatumbazo.legiDatumbazon(el: bundleUrl)
	}()
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {
		// Starigi datumbazon
		VortaroDatumbazo.komuna = VortaroDatumbazo(konteksto: datumbazKonteksto)
		
		// Starigi hejmpaĝon
		let serchPagho = SerchoViewController(serchLingvoj: UzantDatumaro.komuna.lingvoj, radika: true)
		let vc = PaghingoViewController(chefpagho: serchPagho)
		let navigaciilo = PRVNavigationController(rootViewController: vc)
		fenestro = UIWindow(frame: UIScreen.main.bounds)
		fenestro?.rootViewController = navigaciilo
		fenestro?.makeKeyAndVisible()
				
		return true
	}
}

