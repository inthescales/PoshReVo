import UIKit

// TODO: Unuigi stilojn? (t.e., uzu nur dinamka aŭ nur simpla)
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
	
	static var senkoloraFono = UIColor(dynamicProvider: { _ in konkretaStilo.senkoloraFono})
	static var koloraFono = UIColor(dynamicProvider: { _ in konkretaStilo.koloraFono})
	static var teksto = UIColor(dynamicProvider: { _ in konkretaStilo.teksto})
	static var ligilo = UIColor(dynamicProvider: { _ in konkretaStilo.ligilo})
	static var surkoloraButono = UIColor(dynamicProvider: { _ in konkretaStilo.surkoloraButono})
	static var surkoloraTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.surkoloraTeksto})
	static var surkoloraMalaktiva = UIColor(dynamicProvider: { _ in konkretaStilo.surkoloraMalaktiva})
}

class InterfacStilo {
	let nomo: String
	let identigilo: String
	
	private var hela: Koloraro
	private var malhela: Koloraro
	
	lazy var senkoloraFono = UIColor(hela: hela.senkoloraFono, malhela: malhela.senkoloraFono)
	lazy var koloraFono = UIColor(hela: hela.koloraFono, malhela: malhela.koloraFono)
	
	lazy var teksto = UIColor(hela: hela.teksto, malhela: malhela.teksto)
	lazy var ligilo = UIColor(hela: hela.ligilo, malhela: malhela.ligilo)
	
	lazy var surkoloraButono = UIColor(hela: hela.surkoloraButono, malhela: malhela.surkoloraButono)
	lazy var surkoloraTeksto = UIColor(hela: hela.surkoloraTeksto, malhela: malhela.surkoloraTeksto)
	lazy var surkoloraMalaktiva = UIColor(hela: hela.surkoloraMalaktiva, malhela: malhela.surkoloraMalaktiva)
	
	init(nomo: String, identigilo: String, hela: Koloraro, malhela: Koloraro) {
		self.nomo = nomo
		self.identigilo = identigilo
		self.hela = hela
		self.malhela = malhela
	}
	
	static func kun(nomo: String) -> InterfacStilo? {
		return .chiuj.first(where: { stilo in stilo.nomo == nomo })
	}
	
	static let karamela = InterfacStilo(
		nomo: "karamela",
		identigilo: "karamela",
		hela: Koloraro(
			senkoloraFono: .white,
			koloraFono: .orange,
			teksto: .black,
			ligilo: .brown,
			surkoloraButono: .white,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .brown
		),
		malhela: Koloraro(
			senkoloraFono: .black, 
			koloraFono: .brown,
			teksto: .white,
			ligilo: .brown,
			surkoloraButono: .black,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .brown
		)
	)
	
	static let verda = InterfacStilo(
		nomo: "verda",
		identigilo: "verda",
		hela: Koloraro(
			senkoloraFono: .white,
			koloraFono: .green,
			teksto: .black,
			ligilo: .green,
			surkoloraButono: .white,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .green
		),
		malhela: Koloraro(
			senkoloraFono: .black,
			koloraFono: .green,
			teksto: .white,
			ligilo: .green,
			surkoloraButono: .black,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .green
		)
	)
	
	static var chiuj: [InterfacStilo] = [
		.karamela,
		.verda
	]
}

struct Koloraro {
	var senkoloraFono: UIColor
	var koloraFono: UIColor
	var teksto: UIColor
	var ligilo: UIColor
	var surkoloraButono: UIColor
	var surkoloraTeksto: UIColor
	var surkoloraMalaktiva: UIColor
}

// Helpiloj

extension UIColor {
	convenience init(hela: UIColor, malhela: UIColor) {
		self.init(dynamicProvider: { trajtaro in
			switch Stilo.el(trajtaro: trajtaro) {
			case .hela:
				return hela
			case .malhela:
				return malhela
			}
		})
	}
}
