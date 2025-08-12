import UIKit

extension InterfacStilo {
	static let simpla = InterfacStilo(
		nomo: "Simpla",
		identigilo: "simpla",
		hela: {
			let verda = UIColor(deksesuma: 0x0a9618)
			let helverda = UIColor(deksesuma: 0x06dd1c)
			let palgriza = UIColor(deksesuma: 0xf2f2f2)
			let mezgriza = UIColor(deksesuma: 0x888888)
			let fortgriza = UIColor(deksesuma: 0x555555)
			let malhelgriza = UIColor(deksesuma: 0x303030)
			
			return Koloraro(
				navigaciaFono: .white,
				navigaciaTeksto: .black,
				navigaciaSerchilo: palgriza,
				navigaciaButono: verda,
				navigaciaButonoMalaktiva: mezgriza,
				dokumentaFono: .white,
				dokumentaAlternaFono: palgriza,
				dokumentaTeksto: .black,
				dokumentaMalfortaTeksto: fortgriza,
				dokumentaDividilo: mezgriza,
				dokumentLigilo: verda,
				dokumentLigiloPremita: helverda,
				dokumentSencNumero: malhelgriza,
				dokumentEkzemplo: malhelgriza,
				dokumentRimarko: .black,
				menuoFono: palgriza,
				menuaTekstejo: .white,
				shovmenuaFono: .white,
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let verda = UIColor(deksesuma: 0x14c926)
			let helverda = UIColor(deksesuma: 0x0cf223)
			let malhelgriza = UIColor(deksesuma: 0x1C1F1C)
			let malheletgriza = UIColor(deksesuma: 0x1F221F)
			let mezgriza = UIColor(deksesuma: 0x222f22)
			let helgriza = UIColor(deksesuma: 0x888f88)
			let heleggriza = UIColor(deksesuma: 0xcfcfcf)
			
			return Koloraro(
				navigaciaFono: .black,
				navigaciaTeksto: .white,
				navigaciaSerchilo: malhelgriza,
				navigaciaButono: verda,
				navigaciaButonoMalaktiva: helgriza,
				dokumentaFono: .black,
				dokumentaAlternaFono: malheletgriza,
				dokumentaTeksto: .white,
				dokumentaMalfortaTeksto: helgriza,
				dokumentaDividilo: helgriza,
				dokumentLigilo: verda,
				dokumentLigiloPremita: helverda,
				dokumentSencNumero: heleggriza,
				dokumentEkzemplo: heleggriza,
				dokumentRimarko: .white,
				menuoFono: .black,
				menuaTekstejo: malhelgriza,
				shovmenuaFono: malhelgriza,
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
