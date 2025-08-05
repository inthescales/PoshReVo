import UIKit

extension InterfacStilo {
	static let pergamena = InterfacStilo(
		nomo: "pergamena",
		identigilo: "pergamena",
		hela: {
			let teksto = UIColor(deksesuma: 0x121221)
			let malfortaTeksto = UIColor(deksesuma: 0x84756f)
			let helaPagho = UIColor(deksesuma: 0xffedd1)
			let mezaPagho = UIColor(deksesuma: 0xeddcc2)
			let malhelaPagho = UIColor(deksesuma: 0xe0ccaf)
			let ligilblua = UIColor(deksesuma: 0x285fcc)
			let brunaTeksto = UIColor(deksesuma: 0x66401f)
			let malhelrugha = UIColor(deksesuma: 0x872940)
			
			return Koloraro(
				navigaciaFono: malhelaPagho,
				navigaciaTeksto: teksto,
				navigaciaSerchilo: helaPagho,
				navigaciaButono: ligilblua,
				navigaciaButonoMalaktiva: malfortaTeksto,
				dokumentaFono: helaPagho,
				dokumentaAlternaFono: malhelaPagho,
				dokumentaTeksto: teksto,
				dokumentaMalfortaTeksto: malfortaTeksto,
				dokumentaDividilo: malfortaTeksto,
				dokumentLigilo: ligilblua,
				dokumentEkzemplo: brunaTeksto,
				dokumentRimarko: malhelrugha,
				menuoFono: mezaPagho,
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let malhelaPagho = UIColor(deksesuma: 0x332f29)
			let heletaPagho = UIColor(deksesuma: 0x47423a)
			let teksto = UIColor(deksesuma: 0xddd0ba)
			let malfortaTeksto = UIColor(deksesuma: 0x897f6e)
			let ligilBlua = UIColor(deksesuma: 0x86b3d8)
			
			return Koloraro(
				navigaciaFono: heletaPagho,
				navigaciaTeksto: teksto,
				navigaciaSerchilo: malhelaPagho,
				navigaciaButono: ligilBlua,
				navigaciaButonoMalaktiva: malfortaTeksto,
				dokumentaFono: malhelaPagho,
				dokumentaAlternaFono: heletaPagho,
				dokumentaTeksto: teksto,
				dokumentaMalfortaTeksto: malfortaTeksto,
				dokumentaDividilo: malfortaTeksto,
				dokumentLigilo: ligilBlua,
				dokumentEkzemplo: UIColor(deksesuma: 0xe0991f),
				dokumentRimarko: UIColor(deksesuma: 0xdd9da2),
				menuoFono: heletaPagho, // TODO: Fari nove
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
