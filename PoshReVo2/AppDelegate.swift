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
		VortaroDatumbazo.komuna = VortaroDatumbazo(konteksto: datumbazKonteksto)
		// UzantDatumaro.starigi()
		
		// let vc = LingvaroRedaktiloViewController(lingvaro: [Lingvo.esperanto], kompleti: { _ in })
		let vc = SerchoViewController(serchLingvoj: [
			Lingvo.esperanto,
			Lingvo(kodo: "en", nomo: "angla"),
			Lingvo(kodo: "es", nomo: "hispana"),
			Lingvo(kodo: "de", nomo: "germana"),
			Lingvo(kodo: "fr", nomo: "franca"),
			Lingvo(kodo: "is", nomo: "islanda")
		])
		let navigaciilo = ChefaNavigationController(rootViewController: vc)
		
		fenestro = UIWindow(frame: UIScreen.main.bounds)
		fenestro?.rootViewController = navigaciilo
		fenestro?.makeKeyAndVisible()
				
		return true
	}
}

