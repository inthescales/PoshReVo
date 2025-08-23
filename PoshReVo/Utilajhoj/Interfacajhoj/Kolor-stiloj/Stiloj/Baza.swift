import UIKit

extension InterfacStilo {
	/// Interfacstilo havanta plejparte ordinaran iOS-an aspekton
	static let simpla = InterfacStilo(
		nomo: "Baza",
		identigilo: "baza",
		hela: {
			let verda = UIColor(deksesuma: 0x098916)
			let helverda = UIColor(deksesuma: 0x0cb21d)
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
				dokumentSencNumero: .black,
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
			let heleggriza = UIColor(deksesuma: 0xe0e0e0)
			
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
				dokumentSencNumero: .white,
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
