import UIKit

extension InterfacStilo {
	static let klara = InterfacStilo(
		nomo: "klara",
		identigilo: "klaraverda",
		hela: {
			let verda = UIColor(deksesuma: 0x0a9618)
			
			return Koloraro(
				navigaciaFono: .white,
				navigaciaTeksto: .black,
				navigaciaSerchilo: UIColor(deksesuma: 0xf2f2f2),
				navigaciaButono: verda,
				navigaciaButonoMalaktiva: .black.withAlphaComponent(0.5),
				dokumentaFono: .white,
				dokumentaAlternaFono: UIColor(deksesuma: 0xcccccc),
				dokumentaTeksto: .black,
				dokumentaMalfortaTeksto: .black.withAlphaComponent(0.5),
				dokumentaDividilo: .black.withAlphaComponent(0.5),
				dokumentLigilo: verda,
				dokumentEkzemplo: .black.withAlphaComponent(0.9),
				dokumentRimarko: .black.withAlphaComponent(0.9),
				menuoFono: UIColor(deksesuma: 0xf2f2f2),
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let heletaPagho = UIColor(deksesuma: 0x47423a)
			let teksto = UIColor(deksesuma: 0xddd0ba)
			let malfortaTeksto = UIColor(deksesuma: 0x897f6e)
			let ligilBlua = UIColor(deksesuma: 0x86b3d8)
			
			return Koloraro(
				navigaciaFono: heletaPagho,
				navigaciaTeksto: teksto,
				navigaciaSerchilo: .white,
				navigaciaButono: ligilBlua,
				navigaciaButonoMalaktiva: malfortaTeksto,
				dokumentaFono: UIColor(deksesuma: 0x332f29),
				dokumentaAlternaFono: heletaPagho,
				dokumentaTeksto: teksto,
				dokumentaMalfortaTeksto: malfortaTeksto,
				dokumentaDividilo: malfortaTeksto,
				dokumentLigilo: ligilBlua,
				dokumentEkzemplo: UIColor(deksesuma: 0xe0991f),
				dokumentRimarko: UIColor(deksesuma: 0xdd9da2),
				menuoFono: heletaPagho,
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
