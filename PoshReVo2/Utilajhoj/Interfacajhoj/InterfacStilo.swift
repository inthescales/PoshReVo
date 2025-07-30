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
	
	static var navigaciaFono = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaFono })
	static var navigaciaTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaTeksto })
	static var navigaciaButono = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaButono })
	static var navigaciaButonoMalaktiva = UIColor(dynamicProvider: { _ in konkretaStilo.navigaciaButonoMalaktiva })
	
	static var dokumentaFono = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaFono })
	static var dokumentaAlternaFono = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaAlternaFono })
	static var dokumentaTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaTeksto })
	static var dokumentaDividilo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaDividilo })
	static var dokumentLigilo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentLigilo })
	
	static var dokumentEkzemplo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentEkzemplo })
	static var dokumentRimarko = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentRimarko })
}

class InterfacStilo {
	let nomo: String
	let identigilo: String
	
	private var hela: Koloraro
	private var malhela: Koloraro
	
	lazy var navigaciaFono = UIColor(hela: hela.navigaciaFono, malhela: malhela.navigaciaFono)
	lazy var navigaciaButono = UIColor(hela: hela.navigaciaButono, malhela: malhela.navigaciaButono)
	lazy var navigaciaButonoMalaktiva = UIColor(hela: hela.navigaciaButonoMalaktiva, malhela: malhela.navigaciaButonoMalaktiva)
	lazy var navigaciaTeksto = UIColor(hela: hela.navigaciaTeksto, malhela: malhela.navigaciaTeksto)
	
	lazy var dokumentaFono = UIColor(hela: hela.dokumentaFono, malhela: malhela.dokumentaFono)
	lazy var dokumentaAlternaFono = UIColor(hela: hela.dokumentaAlternaFono, malhela: malhela.dokumentaAlternaFono)
	lazy var dokumentaTeksto = UIColor(hela: hela.dokumentaTeksto, malhela: malhela.dokumentaTeksto)
	lazy var dokumentaDividilo = UIColor(hela: hela.dokumentaDividilo, malhela: malhela.dokumentaDividilo)
	lazy var dokumentLigilo = UIColor(hela: hela.dokumentLigilo, malhela: malhela.dokumentLigilo)
	lazy var dokumentEkzemplo = UIColor(hela: hela.dokumentEkzemplo, malhela: malhela.dokumentEkzemplo)
	lazy var dokumentRimarko = UIColor(hela: hela.dokumentRimarko, malhela: malhela.dokumentRimarko)
	
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
			navigaciaFono: .orange,
			navigaciaTeksto: .white,
			navigaciaButono: .white,
			navigaciaButonoMalaktiva: .brown,
			dokumentaFono: .white,
			dokumentaAlternaFono: .systemGroupedBackground,
			dokumentaTeksto: .black,
			dokumentaDividilo: .lightGray,
			dokumentLigilo: .brown,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown
		),
		malhela: Koloraro(
			navigaciaFono: .brown,
			navigaciaTeksto: .white,
			navigaciaButono: .black,
			navigaciaButonoMalaktiva: .brown,
			dokumentaFono: .black,
			dokumentaAlternaFono: .gray,
			dokumentaTeksto: .white,
			dokumentaDividilo: .gray,
			dokumentLigilo: .brown,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown
		)
	)
	
	static let verda = InterfacStilo(
		nomo: "verda",
		identigilo: "verda",
		hela: Koloraro(
			navigaciaFono: .green,
			navigaciaTeksto: .white,
			navigaciaButono: .white,
			navigaciaButonoMalaktiva: .green,
			dokumentaFono: .white,
			dokumentaAlternaFono: .systemGroupedBackground,
			dokumentaTeksto: .black,
			dokumentaDividilo: .lightGray,
			dokumentLigilo: .green,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown
		),
		malhela: Koloraro(
			navigaciaFono: .green,
			navigaciaTeksto: .white,
			navigaciaButono: .white,
			navigaciaButonoMalaktiva: .green,
			dokumentaFono: .black,
			dokumentaAlternaFono: .gray,
			dokumentaTeksto: .white,
			dokumentaDividilo: .gray,
			dokumentLigilo: .green,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown
		)
	)
	
	static var chiuj: [InterfacStilo] = [
		.karamela,
		.verda
	]
}

struct Koloraro {
	var navigaciaFono: UIColor
	var navigaciaTeksto: UIColor
	var navigaciaButono: UIColor
	var navigaciaButonoMalaktiva: UIColor
	var dokumentaFono: UIColor
	var dokumentaAlternaFono: UIColor
	var dokumentaTeksto: UIColor
	var dokumentaDividilo: UIColor
	var dokumentLigilo: UIColor
	var dokumentEkzemplo: UIColor
	var dokumentRimarko: UIColor
}

// MARK: - Helpiloj

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
