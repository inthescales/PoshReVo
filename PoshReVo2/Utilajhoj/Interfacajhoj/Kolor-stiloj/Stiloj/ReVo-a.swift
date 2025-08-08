import UIKit

extension InterfacStilo {
	static let revoa = InterfacStilo(
		nomo: "ReVo-a",
		identigilo: "revoa",
		hela: {
			
			// let flava = UIColor(deksesuma: 0xEAB530) // Uzata kiel navigacia fono en la retejo
			
			let palflava = UIColor(deksesuma: 0xFAFBD2)
			let paletflava = UIColor(deksesuma: 0xf1f2cb)
			let palgriza = UIColor(deksesuma: 0xf2f2f2)
			let mezgriza = UIColor(deksesuma: 0x888888)
			let fortgriza = UIColor(deksesuma: 0x555555)
			
			let teksta = UIColor.black
			let ligila = UIColor(deksesuma: 0x600000)
			let etikeda = UIColor(deksesuma: 0x104040)
			let ekzempla = UIColor(deksesuma: 0x303030)
			let noktomeza = UIColor(deksesuma: 0x191970)
			
			return Koloraro(
				navigaciaFono: palflava,
				navigaciaTeksto: teksta,
				navigaciaSerchilo: .white,
				navigaciaButono: ligila,
				navigaciaButonoMalaktiva: mezgriza,
				dokumentaFono: palflava,
				dokumentaAlternaFono: paletflava,
				dokumentaTeksto: teksta,
				dokumentaMalfortaTeksto: fortgriza,
				dokumentaDividilo: fortgriza,
				dokumentLigilo: ligila,
				dokumentSencNumero: etikeda,
				dokumentEkzemplo: ekzempla,
				dokumentRimarko: noktomeza,
				menuoFono: paletflava,
				menuaTekstejo: palflava,
				shovmenuaFono: palflava,
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let nigra = UIColor(deksesuma: 0x0F0800)
			let palflava = UIColor(deksesuma: 0xFFFFE0)
			let mezflava = UIColor(deksesuma: 0xccccb3)
			let palblua = UIColor(deksesuma: 0x87CEEB)
			let orangha = UIColor(deksesuma: 0xFFA500) // Ankaŭ navigacia fonkoloro en la retejo
			let shokolada = UIColor(deksesuma: 0xD2691E)
			let helgriza = UIColor(deksesuma: 0x888f88)
			let mezgriza = UIColor(deksesuma: 0x222f22)
			let malheletgriza = UIColor(deksesuma: 0x1F221F)
			let malhelgriza = UIColor(deksesuma: 0x1C1F1C)
			
			return Koloraro(
				navigaciaFono: nigra,
				navigaciaTeksto: palflava,
				navigaciaSerchilo: malhelgriza,
				navigaciaButono: shokolada,
				navigaciaButonoMalaktiva: helgriza,
				dokumentaFono: nigra,
				dokumentaAlternaFono: malheletgriza,
				dokumentaTeksto: palflava,
				dokumentaMalfortaTeksto: mezflava,
				dokumentaDividilo: mezflava,
				dokumentLigilo: shokolada,
				dokumentSencNumero: orangha,
				dokumentEkzemplo: orangha,
				dokumentRimarko: palblua,
				menuoFono: nigra,
				menuaTekstejo: malhelgriza,
				shovmenuaFono: malhelgriza,
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
