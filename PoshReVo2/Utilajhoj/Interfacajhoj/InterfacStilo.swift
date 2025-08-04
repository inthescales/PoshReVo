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
	static var dokumentaMalfortaTeksto = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaMalfortaTeksto})
	static var dokumentaDividilo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentaDividilo })
	static var dokumentLigilo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentLigilo })
	
	static var dokumentEkzemplo = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentEkzemplo })
	static var dokumentRimarko = UIColor(dynamicProvider: { _ in konkretaStilo.dokumentRimarko })

	static var ombro = UIColor(dynamicProvider: { _ in konkretaStilo.ombro })
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
	lazy var dokumentaMalfortaTeksto = UIColor(hela: hela.dokumentaMalfortaTeksto, malhela: malhela.dokumentaMalfortaTeksto)
	lazy var dokumentaDividilo = UIColor(hela: hela.dokumentaDividilo, malhela: malhela.dokumentaDividilo)
	lazy var dokumentLigilo = UIColor(hela: hela.dokumentLigilo, malhela: malhela.dokumentLigilo)
	lazy var dokumentEkzemplo = UIColor(hela: hela.dokumentEkzemplo, malhela: malhela.dokumentEkzemplo)
	lazy var dokumentRimarko = UIColor(hela: hela.dokumentRimarko, malhela: malhela.dokumentRimarko)
	
	lazy var ombro = UIColor(hela: hela.ombro, malhela: malhela.ombro)
	
	init(nomo: String, identigilo: String, hela: Koloraro, malhela: Koloraro) {
		self.nomo = nomo
		self.identigilo = identigilo
		self.hela = hela
		self.malhela = malhela
	}
	
	static func kun(nomo: String) -> InterfacStilo? {
		return .chiuj.first(where: { stilo in stilo.nomo == nomo })
	}
	
	static let pergamena = InterfacStilo(
		nomo: "pergamena",
		identigilo: "pergamena",
		hela: {
			let teksto = UIColor(deksesuma: 0x121221)
			let malfortaTeksto = UIColor(deksesuma: 0x84756f)
			let helaPagho = UIColor(deksesuma: 0xffedd1)
			let mezaPagho = UIColor(deksesuma: 0xf2d9b3)
			let malhelaPagho = UIColor(deksesuma: 0xe0c9a6)
			let ligilblua = UIColor(deksesuma: 0x285fcc)
			let brunaTeksto = UIColor(deksesuma: 0x66401f)
			let malhelrugha = UIColor(deksesuma: 0x872940)
			
			return Koloraro(
				navigaciaFono: malhelaPagho,
				navigaciaTeksto: teksto,
				navigaciaButono: ligilblua,
				navigaciaButonoMalaktiva: malfortaTeksto,
				dokumentaFono: helaPagho,
				dokumentaAlternaFono: malhelaPagho,
				dokumentaTeksto: teksto,
				dokumentaMalfortaTeksto: malfortaTeksto,
				dokumentaDividilo: UIColor(deksesuma: 0xa08c6d),
				dokumentLigilo: ligilblua,
				dokumentEkzemplo: brunaTeksto,
				dokumentRimarko: malhelrugha,
				ombro: UIColor.black.withAlphaComponent(0.5)
			)
		}(),
		malhela: Koloraro(
			navigaciaFono: .brown,
			navigaciaTeksto: .white,
			navigaciaButono: .black,
			navigaciaButonoMalaktiva: .brown,
			dokumentaFono: .black,
			dokumentaAlternaFono: .gray,
			dokumentaTeksto: .white,
			dokumentaMalfortaTeksto: .white.withAlphaComponent(0.6),
			dokumentaDividilo: .gray,
			dokumentLigilo: .brown,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown,
			ombro: UIColor.black.withAlphaComponent(0.5)
		)
	)
	
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
			dokumentaMalfortaTeksto: .black.withAlphaComponent(0.6),
			dokumentaDividilo: .lightGray,
			dokumentLigilo: .brown,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown,
			ombro: UIColor.black.withAlphaComponent(0.5)
		),
		malhela: Koloraro(
			navigaciaFono: .brown,
			navigaciaTeksto: .white,
			navigaciaButono: .black,
			navigaciaButonoMalaktiva: .brown,
			dokumentaFono: .black,
			dokumentaAlternaFono: .gray,
			dokumentaTeksto: .white,
			dokumentaMalfortaTeksto: .white.withAlphaComponent(0.6),
			dokumentaDividilo: .gray,
			dokumentLigilo: .brown,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown,
			ombro: UIColor.black.withAlphaComponent(0.5)
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
			dokumentaMalfortaTeksto: .black.withAlphaComponent(0.6),
			dokumentaDividilo: .lightGray,
			dokumentLigilo: .green,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown,
			ombro: UIColor.black.withAlphaComponent(0.5)
		),
		malhela: Koloraro(
			navigaciaFono: .green,
			navigaciaTeksto: .white,
			navigaciaButono: .white,
			navigaciaButonoMalaktiva: .green,
			dokumentaFono: .black,
			dokumentaAlternaFono: .gray,
			dokumentaTeksto: .white,
			dokumentaMalfortaTeksto: .white.withAlphaComponent(0.6),
			dokumentaDividilo: .gray,
			dokumentLigilo: .green,
			dokumentEkzemplo: .brown,
			dokumentRimarko: .brown,
			ombro: UIColor.black.withAlphaComponent(0.5)
		)
	)
	
	static var defaulta: InterfacStilo = .pergamena
	
	static var chiuj: [InterfacStilo] = [
		.pergamena,
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
	var dokumentaMalfortaTeksto: UIColor
	var dokumentaDividilo: UIColor
	var dokumentLigilo: UIColor
	var dokumentEkzemplo: UIColor
	var dokumentRimarko: UIColor
	var ombro: UIColor
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
