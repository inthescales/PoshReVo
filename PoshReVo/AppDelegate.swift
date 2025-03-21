import CoreData

import UIKit
import iOS_Slide_Menu

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
        
        UzantDatumaro.starigi()
        
        let navilo = ChefaNavigationController()
        
        fenestro = UIWindow(frame: UIScreen.main.bounds)
        fenestro?.rootViewController = navilo
        fenestro?.makeKeyAndVisible()
        
        Stiloj.efektivigiStilon(UzantDatumaro.stilo)
        
        return true
    }
}

