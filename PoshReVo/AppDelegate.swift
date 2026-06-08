import CoreData
import UIKit

import ReVoDatumbazo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	/// Datumbaz-konteksto por ĉiuj datumbazaj operacioj
	private lazy var datumbazKonteksto: NSManagedObjectContext = {
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
		
		return true
	}
}

