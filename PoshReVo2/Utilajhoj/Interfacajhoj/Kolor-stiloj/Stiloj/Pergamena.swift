import UIKit

// NOTO: Ĉi tio stilo ne estas finita, kaj ne estas atingebla en la apo nuntempe

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
				dokumentLigiloPremita: ligilblua, // TODO: Premita koloro
				dokumentSencNumero: malhelrugha,
				dokumentEkzemplo: brunaTeksto,
				dokumentRimarko: malhelrugha,
				menuoFono: mezaPagho,
				menuaTekstejo: helaPagho,
				shovmenuaFono: helaPagho,
				ombro: .black.withAlphaComponent(0.5)
			)
		}(),
		malhela: {
			let malhelaPagho = UIColor(deksesuma: 0x332f29)
			let heletaPagho = UIColor(deksesuma: 0x47423a)
			let teksto = UIColor(deksesuma: 0xddd0ba)
			let malfortaTeksto = UIColor(deksesuma: 0x897f6e)
			let ligilblua = UIColor(deksesuma: 0x86b3d8)
			let palrugha = UIColor(deksesuma: 0xdd9da2)
			
			return Koloraro(
				navigaciaFono: heletaPagho,
				navigaciaTeksto: teksto,
				navigaciaSerchilo: malhelaPagho,
				navigaciaButono: ligilblua,
				navigaciaButonoMalaktiva: malfortaTeksto,
				dokumentaFono: malhelaPagho,
				dokumentaAlternaFono: heletaPagho,
				dokumentaTeksto: teksto,
				dokumentaMalfortaTeksto: malfortaTeksto,
				dokumentaDividilo: malfortaTeksto,
				dokumentLigilo: ligilblua,
				dokumentLigiloPremita: ligilblua, // TODO: Premita koloro
				dokumentSencNumero: palrugha,
				dokumentEkzemplo: UIColor(deksesuma: 0xe0991f),
				dokumentRimarko: palrugha,
				menuoFono: heletaPagho,
				menuaTekstejo: malhelaPagho,
				shovmenuaFono: malhelaPagho,
				ombro: .white.withAlphaComponent(0.5)
			)
		}()
	)
}
