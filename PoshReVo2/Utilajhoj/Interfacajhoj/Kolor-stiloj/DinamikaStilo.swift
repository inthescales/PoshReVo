import UIKit

// SOLVO: Faru protokolon kiu unuigos klasojn 'DinamikaStilo' kaj 'KonkretaStilo'.
// Ambaŭ, laŭ la protokolo, havos variablojn reprezentantajn ĉiujn diversajn kolorojn.
// Konkreta, laŭ la nuna 'InterfacStilo', enhavos listojn da helaj kaj malhelaj koloroj.
// Dinamika, laŭ la nuna, ĉerpos la ĝustajn kolorojn el la nune elektita konkreta stilo
//
// Ve, ŝajnas ke tiu supra ideo ne funkcios, ĉar la UIColor.dynamicProvider ne ĝisdatiĝas
// kiam la uzanto elektos novan stilon (ŝajne nur kiam la UITraitCollection ŝanĝiĝas).
// Kelkaj eblecoj ĉi tie: https://christianselig.com/2022/02/difficulty-theming-ios/
class DinamikaStilo {
	private static var konkretaStilo: InterfacStilo {
		UzantDatumaro.komuna.stilo
	}
	
	static var navigaciaFono = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaFono })
	static var navigaciaTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaTeksto })
	static var navigaciaButono = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaButono })
	static var navigaciaButonoMalaktiva = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaButonoMalaktiva })
	
	static var dokumentaFono = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaFono })
	static var dokumentaAlternaFono = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaAlternaFono })
	static var dokumentaTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaTeksto })

	static var shovmenuaFono = UIColor(dynamicProvider: { _ in konkretaStilo.shovmenuaFono })
	
	static var ombro = UIColor(dynamicProvider: { _ in konkretaStilo.ombro })
}
