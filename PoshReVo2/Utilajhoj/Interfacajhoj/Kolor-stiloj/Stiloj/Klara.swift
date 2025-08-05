import UIKit

extension InterfacStilo {
	static let klara = InterfacStilo(
		nomo: "klara",
		identigilo: "klaraverda",
		hela: {
			let verda = UIColor(deksesuma: 0x0a9618)
			let palgriza = UIColor(deksesuma: 0xf2f2f2)
			
			return Koloraro(
				navigaciaFono: .white,
				navigaciaTeksto: .black,
				navigaciaSerchilo: palgriza,
				navigaciaButono: verda,
				navigaciaButonoMalaktiva: .black.withAlphaComponent(0.5),
				dokumentaFono: .white,
				dokumentaAlternaFono: palgriza,
				dokumentaTeksto: .black,
				dokumentaMalfortaTeksto: .black.withAlphaComponent(0.5),
				dokumentaDividilo: .black.withAlphaComponent(0.5),
				dokumentLigilo: verda,
				dokumentEkzemplo: .black.withAlphaComponent(0.8),
				dokumentRimarko: .black.withAlphaComponent(0.8),
				menuoFono: palgriza,
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let verda = UIColor(deksesuma: 0x14b724)
			
			return Koloraro(
				navigaciaFono: .black,
				navigaciaTeksto: .white,
				navigaciaSerchilo: .white,
				navigaciaButono: verda,
				navigaciaButonoMalaktiva: .white.withAlphaComponent(0.5),
				dokumentaFono: .black,
				dokumentaAlternaFono: .white.withAlphaComponent(0.5),
				dokumentaTeksto: .white,
				dokumentaMalfortaTeksto: .white.withAlphaComponent(0.5),
				dokumentaDividilo: .white.withAlphaComponent(0.5),
				dokumentLigilo: verda,
				dokumentEkzemplo: .white.withAlphaComponent(0.8),
				dokumentRimarko: .white.withAlphaComponent(0.8),
				menuoFono: UIColor(deksesuma: 0x1C1C1E),
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
